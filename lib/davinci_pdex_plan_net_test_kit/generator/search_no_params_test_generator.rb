require_relative 'naming'
require_relative 'special_cases'

module DaVinciPDEXPlanNetTestKit
  class Generator
    class SearchNoParamsTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.groups
            .reject { |group| SpecialCases.exclude_group? group }
            .select { |group| group.searches.present? }
            .each do |group|
              new(group, base_output_dir).generate
            end
        end
      end

      attr_accessor :group_metadata, :base_output_dir

      def initialize(group_metadata, base_output_dir)
        self.group_metadata = group_metadata
        self.base_output_dir = base_output_dir
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'search_no_params.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        "#{class_name.underscore}.rb"
      end

      def output_file_directory
        File.join(base_output_dir, profile_identifier)
      end

      def output_file_name
        File.join(output_file_directory, base_output_file_name)
      end

      def profile_name
        group_metadata.profile_name
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def test_id
        "davinci_pdex_plan_net_#{group_metadata.reformatted_version}_#{profile_identifier}_no_params_search_test"
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}NoParamsSearchTest"
      end

      def module_name
        "DaVinciPDEXPlanNet#{group_metadata.reformatted_version.upcase}"
      end

      def resource_type
        group_metadata.resource
      end

      def conformance_expectation
        'SHALL'
      end

      def first_search?
        true
      end

      def optional?
        false
      end

      def saves_delayed_references?
        first_search? && group_metadata.delayed_references.present?
      end

      def test_post_search?
        false
      end

      def search_properties
        {}.tap do |properties|
          properties[:first_search] = 'true' if first_search?
          properties[:resource_type] = "'#{resource_type}'"
          properties[:saves_delayed_references] = 'true' if saves_delayed_references?
          properties[:test_post_search] = 'false'
        end
      end

      def search_test_properties_string
        search_properties
          .map { |key, value| "#{' ' * 8}#{key}: #{value}" }
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

      def description
        <<~DESCRIPTION.gsub(/\n{3,}/, "\n\n")
        This test gathers instances expected to conform to the target profile
        for use in the rest of the tests in this sequence. It will perform
        an unparameterized search and/or read instance ids provided by the tester
        as described in the "Instance Gathering" section of the group description above.
        DESCRIPTION
      end
    end
  end
end
