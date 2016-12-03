require 'yard'

module YARD::CodeObjects
  module Chef
    class RecipeObject < ChefObject
      register_element :recipe

      attr_accessor :header

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

      # Returns the file for the recipe source
      #
      # @return [String] The recipes file based on the recipe name
      #
      def file
        "recipes/#{@name}.rb"
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
