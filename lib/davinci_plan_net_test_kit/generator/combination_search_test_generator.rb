require_relative 'naming'
require_relative 'special_cases'

module DaVinciPlanNetTestKit
  class Generator
    class CombinationSearchTestGenerator
      class << self
        def generate(ig_metadata, examples_hash, base_output_dir)
          examples_hash.keys.each do |group|
            examples_hash[group].each do |combination_example| 
              group_to_add_to = ig_metadata.groups.find { |ig_meta_group| ig_meta_group.name == "plannet_#{group}"}
              new(group_to_add_to, group_to_add_to.searches.first, base_output_dir, combination_example).generate
            end
          end
        end
      end

      attr_accessor :group_metadata, :search_metadata, :base_output_dir, :test_data

      def initialize(group_metadata, search_metadata, base_output_dir, combination_example)
        self.group_metadata = group_metadata
        self.search_metadata = search_metadata
        self.base_output_dir = base_output_dir
        self.test_data = combination_example
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'combination_search_test.rb.erb'))
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
        "davinci_plan_net_#{group_metadata.reformatted_version}_#{profile_identifier}_#{search_identifier}_search_test"
      end

      def search_identifier
        test_data['name'].gsub(/[-:]/, '_').underscore.gsub("organization_affiliation", "org_affil")
      end

      def search_title
        search_identifier.camelize
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}#{search_title}SearchTest"
      end

      def module_name
        "DaVinciPlanNet#{group_metadata.reformatted_version.upcase}"
      end

      def resource_type
        group_metadata.resource
      end

      def additional_resource_type
        test_data['additional_resource_type']
      end

      def test_description
        test_data['description']
      end

      def test_goal
        test_data['goal']
      end

      def search_params
        @search_params ||=
          test_data['base_search_params'].map do |name|
            {
              name: name,
              path: search_definition(name)[:path]
            }
          end
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

      def a_or_an(name)
        ['a','e','i','o','u'].include?(name.first.downcase) ? "an #{name}" : "a #{name}"
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
        "#{search_identifier}_input"
      end

      def optional_input?
        test_data['optional_input']
      end

      def input_description
        test_data['input_description']
      end

      def search_properties
        {}.tap do |properties|
          properties[:fixed_value_search] = 'true' if fixed_value_search?
          properties[:resource_type] = "'#{resource_type}'"
          properties[:search_param_names] = search_param_names_array
          properties[:input_name] = "'#{input_name}'"
          properties[:include_param] ="'#{test_data['include_param']}'" if !test_data['include_param'].empty?
          properties[:inc_param_sp] ="'#{test_data['inc_param_sp']}'" if !test_data['inc_param_sp'].empty?
          properties[:reverse_chain_param] = "'#{test_data['reverse_chain_param']}'" if !test_data['reverse_chain_param'].empty?
          properties[:reverse_chain_target] = "'#{test_data['reverse_chain_target']}'" if !test_data['reverse_chain_target'].empty?
          properties[:possible_status_search] = 'true' if possible_status_search?
          properties[:additional_resource_type] = "'#{additional_resource_type}'"
          properties[:combination_search] = 'true'
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
