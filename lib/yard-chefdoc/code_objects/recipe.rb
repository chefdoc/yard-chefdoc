require 'yard'

module YARD::CodeObjects
  module Chef
    class RecipeObject < ChefObject
      register_element :recipe

      # Creates a new instance of RecipeObject.
      #
      # @param namespace [NamespaceObject] namespace to which the recipe belongs
      # @param name [String] name of the recipe
      #
      # @return [RecipeObject] the newly created RecipeObject
      #
      def initialize(namespace, name)
        super(namespace, name)
      end

      # Needed by the template to render recipe source code.
      # Since we always display the full source we start with 1
      #
      # @return [Integer] 1
      #
      def line
        1
      end
    end
  end
end
