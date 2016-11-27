require 'yard'

module YARD::Handlers
  module Chef
    # Handles specific cookbook information like README, description and version.
    #
    class CookbookHandler < Base
      handles FileMatcher.new(/metadata.json/)

      # TODO: Add more metadata information to the cookbook object
      #       For now the required name and version are ok
      def process
        metadata = JSON.parse(File.read(File.expand_path(statement.file)))
        base_dir = File.dirname(statement.file)

        cookbook_obj = cookbook
        cookbook_obj.name = metadata['name']
        cookbook_obj.version = metadata['version']
        cookbook_obj.docstring = docstring(base_dir)
        cookbook_obj.docstring_type = :markdown
      end

      # Generates docstring from the README file.
      #
      # @return [YARD::Docstring] the docstring
      #
      def docstring(base_dir)
        string = ''
        readme_path = base_dir + '/README.md'
        string = IO.read(readme_path) if File.exist?(readme_path)

        YARD::DocstringParser.new.parse(string).to_docstring
      end
    end
  end
end
