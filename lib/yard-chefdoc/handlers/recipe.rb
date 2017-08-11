require 'yard'

module YARD::Handlers
  module Chef
    # Handles "recipes" in a cookbook.
    class RecipeHandler < Base
      in_file(%r{^recipes\/.*\.rb$})
      handles(/.*/) # Handle the file itself, so everything in it

      def process
        ChefObject.register(name, :recipe, statement.file)
      end

      # Gives the name of the recipe which is the Filename.
      #
      # @return [String] the recipe name
      #
      def name
        File.basename(statement.file, '.rb')
      end
    end
  end
end
