require 'yard'
require 'json'

require 'yard-chefdoc/code_objects/chef'
require 'yard-chefdoc/code_objects/cookbook'
require 'yard-chefdoc/code_objects/recipe'
require 'yard-chefdoc/code_objects/attribute'
require 'yard-chefdoc/code_objects/resource'

require 'yard-chefdoc/handlers/base'
require 'yard-chefdoc/handlers/cookbook'
require 'yard-chefdoc/handlers/recipe'
require 'yard-chefdoc/handlers/attribute'
require 'yard-chefdoc/handlers/resource_property'
require 'yard-chefdoc/handlers/resource_action'

require 'yard-chefdoc/template_helpers/chef.rb'

require 'yard-chefdoc/version'

module YARD::CodeObjects
  module Chef
    # Initialize the whole magic
    namespace = ChefObject.new(nil, :root)
    CookbookObject.new(namespace, :root)
  end

  # YARD::Tags::Library.define_tag('Recipe description', :recipe)

  # Register template directory for the chef plugin
  template_dir = File.expand_path('../templates', File.dirname(__FILE__))
  YARD::Templates::Engine.register_template_path(template_dir.to_s)
end

module YARD
  module CLI
    class Yardoc
      # This overrides the method from Yard adding Chefs own objects to be rendered
      # as individual pages. This adds recipes, attributes...
      # @return [Array<CodeObjects::Base>] a list of code objects to process
      def all_objects
        Registry.all(:root, :module, :class, :recipe, :attribute)
      end
    end
  end
end
