class KmmObject
  extend ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Serializers::JSON
  include ActiveModel::Serializers::Xml

  def to_xml(options = {}, &block)
    options[:dasherize] = false
    super
  end
end
