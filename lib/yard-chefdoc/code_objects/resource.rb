require 'yard'

module YARD::CodeObjects
  module Chef
    class ResourceObject < ChefObject
      register_element :resource
      attr_accessor :properties,
                    :actions,
                    :default_action,
                    :resource_name,
                    :load_current_value

      # Creates a new instance of the ResourceObject
      #
      # @param namespace [NamespaceObject] namespace to which the resource belongs
      # @param name [String] name of the resource. This is the base name which chef
      #                      automatically generates.
      #
      # @return [ResourceObject] the newly created ResourceObject
      #
      def initialize(namespace, name)
        super(namespace, name)
        @resource_name = name
        @properties = []
        @actions = []
      end

      # Add a single property as an Property object (see below)
      #
      # @param h [Hash] The property hash to add
      #
      def add_property(h)
        @properties.push(Property.new(h))
      end

      # Add an action as an Action object (see below)
      #
      # @param h [Hash] The action hash to add
      #
      def add_action(h)
        @actions.push(Action.new(h))
      end
    end

    # Simple class to handle Properties and their specifics
    # Full docs here http://www.rubydoc.info/gems/chef/Chef%2FMixin%2FProperties%2FClassMethods:property
    class Property
      attr_accessor :identifier, # The name of the property
                    :docstring, # The attrbitues docstring
                    :type, # The ruby type of the property
                    :options # The various property options

      def initialize(h)
        h.each { |k, v| instance_variable_set("@#{k}", v) }
      end
    end

    # Simple class to handle actions
    class Action
      attr_accessor :identifier, # The name of the action
                    :source,     # The source of the action block
                    :docstring,  # The actions docstring
                    :line        # The line number of the first line of the block needed for the output formatting

      def initialize(h)
        h.each { |k, v| instance_variable_set("@#{k}", v) }
      end
    end
  end
end
