require 'json'

module YARD
  module CLI
    class Stats < Yardoc
      STATS_ORDER = %i[files modules classes constants attributes methods
                       chef_attribute_files chef_attributes chef_recipes chef_resources
                       chef_resource_properties chef_resource_actions].freeze

      def stats_for_chef_recipes
        objs = all_objects.select { |m| m.type == :recipe }
        undoc = objs.select { |m| !m.docstring.nil? && m.docstring.blank? }
        @undoc_list |= undoc if @undoc_list
        output 'Chef Recipes', objs.size, undoc.size
      end

      def stats_for_chef_attribute_files
        objs = all_objects.select { |m| m.type == :attribute }
        undoc = objs.select { |m| !m.docstring.nil? && m.docstring.empty? }
        @undoc_list |= undoc if @undoc_list
        output 'Chef Attribute files', objs.size, undoc.size
      end

      def stats_for_chef_attributes
        objs = all_objects.select { |m| m.type == :attribute }
        objs.map!(&:attributes).flatten!
        undoc = objs.select { |m| !m.docstring.nil? && m.docstring.empty? }
        @undoc_list |= undoc if @undoc_list
        output 'Chef Attributes', objs.size, undoc.size
      end

      def stats_for_chef_resources
        objs = all_objects.select { |m| m.type == :resource }
        undoc = objs.select { |m| !m.docstring.nil? && m.docstring.blank? }
        @undoc_list |= undoc if @undoc_list
        output 'Chef Resources', objs.size, undoc.size
      end

      def stats_for_chef_resource_properties
        objs = all_objects.select { |m| m.type == :resource }
        objs.map!(&:properties).flatten!
        undoc = objs.select { |m| !m.docstring.nil? && m.docstring.empty? }
        @undoc_list |= undoc if @undoc_list
        output 'Chef Resource properties', objs.size, undoc.size
      end

      def stats_for_chef_resource_actions
        objs = all_objects.select { |m| m.type == :resource }
        objs.map!(&:actions).flatten!
        undoc = objs.select { |m| !m.docstring.nil? && m.docstring.empty? }
        @undoc_list |= undoc if @undoc_list
        output 'Chef Resource actions', objs.size, undoc.size
      end

      # We don't need the file stats, so remove it
      remove_method :stats_for_files

      # Overrides the output from Yard itself for better indentation
      # Prints a statistic to standard out. This method is optimized for
      # getting Integer values, though it allows any data to be printed.
      #
      # @param [String] name the statistic name
      # @param [Integer, String] data the numeric (or any) data representing
      #   the statistic. If +data+ is an Integer, it should represent the
      #   total objects of a type.
      # @param [Integer, nil] undoc number of undocumented objects for the type
      # @return [void]
      def output(name, data, undoc = nil)
        @total += data if data.is_a?(Integer) && undoc
        @undocumented += undoc if undoc.is_a?(Integer)
        data = if undoc
                 "#{format('%5s', data)} (#{format('%5d', undoc)} undocumented)"
               else
                 format('%5s', data)
               end
        log.puts("#{format('%-25s', name + ':')} #{format('%s', data)}")
      end

      # Returns statistics for machine readable output generation
      #
      # @param [String] name the statistic name
      # @param [Integer, String] data the numeric (or any) data representing
      #   the statistic. If +data+ is an Integer, it should represent the
      #   total objects of a type.
      # @param [Integer, nil] undoc number of undocumented objects for the type
      # @return [Hash] Number of documented and undocumented items
      def output_hash(name, data, undoc = nil)
        @total += data if data.is_a?(Integer) && undoc
        @undocumented += undoc if undoc.is_a?(Integer)
        percent = data.to_i.zero? ? '100' : ((data.to_i - undoc.to_i) / data.to_f) * 100
        { name.tr(' ', '_').downcase => { 'name' => name,
                                          'items' => data.to_i,
                                          'undocumented' => undoc.to_i,
                                          'percentage' => percent } }
      end

      # Prints statistics for different object types in JSON format
      #
      # To add statistics for a specific type, add a method +#stats_for_TYPE+
      # to this class that calls {#output}.
      def print_statistics_json
        log.puts JSON.pretty_generate(statistics_hash)
      end

      def statistics_hash
        # Use JSON output for the following stats_for_* calls
        alias output output_hash # rubocop:disable Style/Alias
        # This is necessary so we get full access to the stats from the templates. Probably a
        # bad patch, but for now this is ok.
        # TODO: Refactor
        options.verifier = YARD::Verifier.new('[:public].include?(object.visibility)')

        collection = {}
        @total = 0
        @undocumented = 0
        meths = methods.map(&:to_s).grep(/^stats_for_/)

        meths.each { |m| collection.merge!(send(m)) }

        collection['total_percentage'] = total_percentage

        collection
      end

      # Always use JSON output by default
      # alias output output_hash
      # alias print_statistics print_statistics_json

      private

      def total_percentage
        if @undocumented.zero?
          100
        elsif @total.zero?
          0
        else
          (@total - @undocumented).to_f / @total.to_f * 100
        end
      end
    end
  end
end
