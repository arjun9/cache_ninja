class FacelessObj
  attr_reader :attributes, :primary_key, :klass

  def initialize(object)
    @attributes = extract_attributes(object)
    @primary_key = extract_primary_key(object)
    @klass = extract_class(object)
    create_getters
    create_association_data_getters
  end

  def create_getters
    attributes.each do |key, value|
      define_singleton_method(key) { value }
    end
  end

  def create_association_data_getters
    return unless klass.respond_to?(:cached_associations)

    klass.cached_associations.each do |association|
      define_singleton_method("cached_#{association}") do
        cached_data = klass.new(attributes).send("cached_#{association}")
        return cached_data if cached_data.present?
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

  private

  def extract_attributes(object)
    object.is_a?(Hash) ? object[:attributes] : object.attributes
  end

  def extract_primary_key(object)
    object.is_a?(Hash) ? object[:primary_key] : object.class.primary_key
  end

  def extract_class(object)
    object.is_a?(Hash) ? object[:klass] : object.class
  end
end
