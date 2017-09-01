require 'yard'

module YARD::Handlers
  module Chef
    # Handles "recipes" in a cookbook.
    class RecipeHandler < Base
      in_file(%r{^recipes\/.*\.rb$})
      handles(/.*/) # Handle the file itself, so everything in it

      def process
        ChefObject.register(filename, :recipe, statement.file)
      end
    end
  end
end
