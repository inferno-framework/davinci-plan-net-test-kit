require_relative 'naming'
require_relative 'special_cases'

module DaVinciPDEXPlanNetTestKit
  class Generator
    class ForwardChainSearchTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.groups
            .reject { |group| SpecialCases.exclude_group? group }
            .each do |group|
                group.searches.each do |search_param|
                    # Grab the name of the search parameter that will be chained upon
                    search_def = group.search_definitions[search_param[:names].first.to_sym]
                    search_def[:chain]&.each { |chain_param| new(group, search_param, base_output_dir, chain_param[:chain]).generate }
                end
            end
        end
      end

      attr_accessor :group_metadata, :search_metadata, :base_output_dir, :chain_param

      def initialize(group_metadata, search_metadata, base_output_dir, chain_param)
        self.group_metadata = group_metadata
        self.search_metadata = search_metadata
        self.base_output_dir = base_output_dir
        self.chain_param = chain_param
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'forward_chain_test.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        "#{class_name.underscore}.rb"
      end

      def output_file_directory
        File.join(base_output_dir, profile_identifier.downcase)
      end

      def output_file_name
        File.join(output_file_directory, base_output_file_name)
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def test_id
        "davinci_plan_net_#{group_metadata.reformatted_version}_#{search_identifier}_forward_chain_search_test"
      end

      def search_identifier
        "#{chain_param_base}_#{chain_param.to_s.gsub(/[-:]/, '_')}".underscore
      end

      def search_title
        search_identifier.camelize
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}#{search_title}ForwardChainSearchTest"
      end

      def module_name
        "DaVinciPDEXPlanNet#{group_metadata.reformatted_version.upcase}"
      end

      def resource_type
        group_metadata.resource
      end

      def first_search?
        group_metadata.searches.first == search_metadata
      end

      def fixed_value_search?
        #TODO
        false
      end

      def fixed_value_search_param_name
        #TODO
      end

      def chain_param_string
        "#{profile_identifier}.#{chain_param.gsub(/[-:]/, '_')}"
      end

      def chain_param_base
        search_metadata[:names].first
      end

      def chained_resource
        res_type = search_definition(chain_param_base.to_sym)[:type]
        res_type = search_definition(chain_param_base.to_sym)[:target] if res_type == "Reference"
        res_type
      end

      def search_param_names
        search_params.map { |param| param[:name] }
      end

      def search_param_names_array
        array_of_strings(search_param_names)
      end

      def path_for_value(path)
        path == 'class' ? 'local_class' : path
      end

      def required_comparators_for_param(name)
        search_definition(name)[:comparators].select { |_comparator, expectation| expectation == 'SHALL' }
      end

      def required_comparators
        @required_comparators ||=
          search_param_names.each_with_object({}) do |name, comparators|
            required_comparators = required_comparators_for_param(name)
            comparators[name] = required_comparators if required_comparators.present?
          end
      end

      def search_definition(name)
        group_metadata.search_definitions[name.to_sym]
      end

      def saves_delayed_references?
        first_search? && group_metadata.delayed_references.present?
      end

      def possible_status_search?
        !search_metadata[:names].include?('status') && group_metadata.search_definitions.key?(:status)
      end

      def token_search_params
        @token_search_params ||=
          search_param_names.select do |name|
            ['Identifier', 'CodeableConcept', 'Coding'].include? group_metadata.search_definitions[name.to_sym][:type]
          end
      end

      def token_search_params_string
        array_of_strings(token_search_params)
      end

      def required_comparators_string
        array_of_strings(required_comparators.keys)
      end

      def array_of_strings(array)
        quoted_strings = array.map { |element| "'#{element}'" }
        "[#{quoted_strings.join(', ')}]"
      end

      def input_name
        "#{search_identifier.downcase}_input"
      end

      def search_properties
        {}.tap do |properties|
          properties[:fixed_value_search] = 'true' if fixed_value_search?
          properties[:resource_type] = "'#{resource_type}'"
          properties[:search_param_names] = []
          properties[:possible_status_search] = 'true' if possible_status_search?
          properties[:chain_param] = "'#{chain_param}'"
          properties[:chain_param_base] = "'#{chain_param_base}'"
          properties[:additional_resource_type] = "'#{chained_resource}'"
        end
      end

      def search_test_properties_string
        search_properties
          .map { |key, value| "#{' ' * 10}#{key}: #{value}" }
          .join(",\n")
      end

      def generate
        FileUtils.mkdir_p(output_file_directory)
        File.open(output_file_name, 'w') { |f| f.write(output) }

        group_metadata.add_test(
          id: test_id,
          file_name: base_output_file_name
        )
      end
    end
  end
end
