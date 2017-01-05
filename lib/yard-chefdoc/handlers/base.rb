require 'yard'

module YARD::Handlers
  module Chef
    # Base handler for chef elements.
    class Base < YARD::Handlers::Ruby::Base
      include YARD::CodeObjects::Chef

      # Gets the name of the handled object.
      #
      def name
        statement.parameters.first.jump(:string_content, :ident).source
      end

      # Registers the cookbook in {YARD::Registry} and returns the same.
      #
      # @return [ChefObject] the ChefObject
      #
      def cookbook
        cbs = YARD::Registry.all(:cookbook)
        raise 'Something went wrong! Found more that one cookbook.' if cbs.length > 1
        raise 'Something went wrong! Could not find any cookbook' if cbs.empty?

        cbs.first
      end

      # Gets the file header if available
      # The header is defined by a every comment line starting at the beginning of the file
      # Until the first blank line. If no blank line is found then the comment is considered
      # the following resource's/blocks docstring.
      #
      # @return [String] The header of the file. Empty if no header is found
      #
      def find_header_in(src)
        h = []
        src.each_line do |line|
          comment = line[/^\s*#\s?(.*)$/, 1]
          break if comment.nil?

          h.push comment
        end

        h.join("\n")
      end

      # Gets the description from the file header.
      # Currently the docstring of recipes, attributes etc. is looked up in the file
      # header and starts with a single line containing the keyword "Description".
      #
      # @return [String] The description
      #
      def find_description_in(header)
        desc_found = false
        docstring = []
        header.each_line do |line|
          if desc_found
            docstring.push line
          elsif line.chomp == 'Description'
            desc_found = true
          end
        end

        docstring.join("\n")
      end
    end
  end
end
