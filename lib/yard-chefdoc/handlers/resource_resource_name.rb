require 'yard'

module YARD::Handlers
  module Chef
    # Handles the resource name in custom resources and LWRPs
    class ResourceResourceNameHandler < Base
      in_file(%r{^resources\/.*\.rb$})
      handles method_call(:resource_name)

      def process
        resource_obj = ChefObject.register(filename, :resource, statement.file)
        resource_obj.resource_name = statement.parameters[0][0][0].source # Gets the first parameter as string
      end
    end
  end
end
