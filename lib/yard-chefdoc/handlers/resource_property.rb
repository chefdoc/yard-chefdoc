require 'yard'

module YARD::Handlers
  module Chef
    # Handles properties in custom resources and LWRPs
    class ResourcePropertyHandler < Base
      in_file(%r{resources\/.*\.rb})
      handles method_call(:property)

      def process
        resource_obj = ChefObject.register(cookbook, name, :resource)

        if resource_obj.initialized.nil?
          src = IO.read(File.expand_path(statement.file))
          resource_obj.header = find_header_in(src)
          resource_obj.docstring = find_description_in(resource_obj.header)
          resource_obj.initialized = true
        end

        docstring_is_header = (statement.docstring == resource_obj.header)
        resource_obj.add_property res_prop_hash(docstring_is_header)
      end

      # Gets the attribute name derived from the filename
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
      def res_prop_hash(nodoc)
        props = {}
        statement[1].entries.each do |e|
          next if e == false
          if %i[var_ref array].include?(e.type)
            props[:type] = e.source
          elsif e.type == :symbol_literal
            props[:identifier] = e.source.delete(':')
          elsif e.type == :list
            props[:options] = parse_option_list(e)
          end
        end
        props[:docstring] = nodoc ? '' : statement.docstring

        props
      end

      # Goes through the option list AST node and returns a simple hash
      #
      # @return [Hash] The options passed as a hash
      #
      def parse_option_list(list)
        return nil if list.nil? || list.empty?
        opts = {}
        list.each do |opt|
          next unless opt.type == :assoc
          opts[opt[0].source.delete(':')] = opt[1].source
        end

        opts
      end
    end
  end
end
