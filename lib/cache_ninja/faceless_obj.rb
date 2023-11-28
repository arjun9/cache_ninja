class FacelessObj
  attr_reader :attributes, :primary_key, :klass

  def initialize(object)
    @attributes = object.is_a?(Hash) ? object[:attributes] : object.attributes
    @primary_key = object.is_a?(Hash) ? object[:primary_key] : object.class.primary_key
    @klass = object.is_a?(Hash) ? object[:klass] : object.class
    create_getters
    create_assoc_data_getters
  end

  def create_getters
    attributes.each do |key, value|
      self.define_singleton_method(key) do
        value
      end
    end
  end

  def create_assoc_data_getters
    return unless klass.respond_to?(:cached_associations)
    klass.cached_associations.each do |association|
      self.define_singleton_method("cached_#{association}") do
        data = klass.new(attributes).send("cached_#{association}")
        return data if data.present?
        klass.new(attributes).send(association)
      end
    end
  end

  def cacheable_data
    {
      attributes: attributes,
      primary_key: primary_key,
      klass: klass
    }
  end
end
