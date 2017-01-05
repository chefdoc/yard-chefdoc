require 'yard'

module YARD::Handlers
  module Chef
    # Handles "recipes" in a cookbook.
    class RecipeHandler < Base
      in_file(%r{recipes\/.*\.rb})
      handles(/.*/) # Handle the file itself, so everything in it

      def process
        recipe_obj = ChefObject.register(cookbook, name, :recipe)

        if recipe_obj.initialized.nil?
          recipe_obj.source = IO.read(File.expand_path(statement.file))
          recipe_obj.header = find_header_in(recipe_obj.source)
          recipe_obj.docstring = find_description_in(recipe_obj.header)
          recipe_obj.initialized = true
        end

        recipe_obj
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
