# frozen_string_literal: true

require 'rails'
require_relative 'cache_ninja/version'
require_relative 'cache_ninja/faceless_obj'

module CacheNinja
  extend ActiveSupport::Concern

  class_methods do
    def cached_associations
      @cached_associations ||= []
    end

    def cache_assoc(associations, options = {})
      return if options[:disable]

      @cached_associations = associations.map(&:to_sym)
      associations.each { |association| create_cached_association_method(association) }
    end
  end

  included do
    after_commit :clear_cached_data

    def self.create_cached_association_method(association)
      define_method("cached_#{association}") do
        key = "#{self.class.name.downcase}_#{id}_cached_#{association}"
        cached_data = Rails.cache.fetch(key) do
          Array(send(association)).compact.map { |obj| FacelessObj.new(obj).cacheable_data }
        end

        singular_assoc = association.to_s.singularize
        data_objs = cached_data.map { |obj| FacelessObj.new(obj) }
        return data_objs.first if association.to_s == singular_assoc
        data_objs
      end
    end

    def self.fetch_cached(id)
      cache_data = Rails.cache.fetch("#{to_s.underscore}/#{id}") do
        obj = find_by(id: id)
        obj && FacelessObj.new(obj).cacheable_data
      end

      FacelessObj.new(cache_data) if cache_data.present?
    end
  end

  def clear_cached_data
    object_cache_key = "#{self.class.to_s.underscore}/#{id}"
    Rails.cache.delete(object_cache_key)

    self_n_parents = collect_parent_classes(self.class)
    self_n_parents.each do |self_n_parent|
      next unless self_n_parent.respond_to?(:cached_associations) && self_n_parent.cached_associations.present?

      self_n_parent.cached_associations.each do |association|
        Rails.cache.delete("#{self_n_parent.name.downcase}_#{id}_cached_#{association}")
        assoc_class_n_id = Array(send(association)).compact.map { |obj| [obj.class, obj.id] }

        assoc_class_n_id.each do |assoc_class, assoc_id|
          assoc_self_n_parents = collect_parent_classes(assoc_class)
          assoc_self_n_parents.each do |assoc_self_n_parent|
            Rails.cache.delete("#{assoc_self_n_parent.name.downcase}_#{assoc_id}_cached_#{self_n_parent.name.underscore.singularize}")
            Rails.cache.delete("#{assoc_self_n_parent.name.downcase}_#{assoc_id}_cached_#{self_n_parent.name.underscore.pluralize}")
          end
        end
      end
    end
  end

  def collect_parent_classes(klass)
    parents = []
    while klass != ActiveRecord::Base
      parents << klass
      klass = klass.superclass
    end
    parents
  end
end
