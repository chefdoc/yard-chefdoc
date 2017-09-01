require 'yard'

module YARD::Handlers
  module Chef
    # Handles the default_action in custom resources and LWRPs
    class ResourceDefaultActionHandler < Base
      in_file(%r{^resources\/.*\.rb$})
      handles method_call(:default_action)

      def process
        resource_obj = ChefObject.register(filename, :resource, statement.file)
        resource_obj.default_action = statement.parameters[0][0][0].source # Gets the first parameter as string
      end
    end
  end
end
