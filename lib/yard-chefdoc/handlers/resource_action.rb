require 'yard'

module YARD::Handlers
  module Chef
    # Handles actions in custom resources and LWRPs
    class ResourceActionHandler < Base
      in_file(%r{resources\/.*\.rb})
      handles method_call(:action)

      def process
        resource_obj = ChefObject.register(name, :resource, statement.file)

        docstring_is_header = (statement.docstring == resource_obj.header)
        resource_obj.add_action action_hash(docstring_is_header)
      end

      # Gets the resource name derived from the filename
      #
      # @return [String] the attribute name
      #
      def name
        File.basename(statement.file, '.rb')
      end

      # Creates the hash to initialize the single resource property object
      #
      # @return [Hash] the hash to initialize the property in the resource code object
      #
      def action_hash(nodoc)
        {
          identifier: statement[1][0].source.to_s[1..-1],
          source: statement.source,
          docstring: nodoc ? '' : statement.docstring,
          line: statement.line
        }
      end
    end
  end
end
