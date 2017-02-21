require 'yard'

module YARD::Handlers
  module Chef
    # Handles specific cookbook information like README, description and version.
    #
    class CookbookHandler < Base
      in_file(/metadata.json/)
      handles(/.*/) # Handle the file itself, so everything in it

      def process
        metadata = JSON.parse(File.read(File.expand_path(statement.file)))
        base_dir = File.dirname(statement.file)

        cookbook_obj = cookbook

        %w(name version dependencies source_url
           issues_url maintainer maintainer_email
           license platforms gems).each do |m|
          cookbook_obj.send("#{m}=", metadata[m]) if metadata.key?(m)
        end

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
