include Helpers::ChefHelper

def init
  sections.push :resource, %i[properties actions]
end

def properties
  return if object.properties.empty?
  erb(:properties)
end

def name_property?(options)
  return false if options.nil?
  options.key?('name_property') && options['name_property'] == 'true'
end
