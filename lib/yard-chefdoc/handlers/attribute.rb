require 'yard'

module YARD::Handlers
  module Chef
    # Handles attributes in cookbook
    class AttributeHandler < Base
      MATCH = /^\s*(node\.)?(default|force_default|normal|override|force_override)(\[.+?\])\s*=\s*(.+)/m
      in_file(%r{attributes\/.*\.rb})
      handles MATCH

      def process
        attrib_obj = ChefObject.register(name, :attribute, statement.file)

        docstring_is_header = (statement.docstring == attrib_obj.header)
        attrib_obj.add attr_hash(docstring_is_header) if statement.type == :assign
      end

      # Gets the attribute name derived from the filename
      #
      # @return [String] the attribute name
      #
      def name
        File.basename(statement.file, '.rb')
      end

      # Creates the hash to initialize the single attribute object
      #
      # @return [Hash] the hash to initialize the attribute in the attribute code object
      #
      def attr_hash(nodoc)
        {
          precedence: statement.jump(:ident).source,
          default: statement.jump(:assign)[1].source,
          docstring: nodoc ? '' : statement.docstring,
          path: statement.source.match(MATCH)[3]
        }
      end
    end
  end
end
