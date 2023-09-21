require_relative 'naming'
require_relative 'special_cases'

module DaVinciPDEXPlanNetTestKit
  class Generator
    class GroupGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.ordered_groups
            .reject { |group| SpecialCases.exclude_group? group }
            .each { |group| new(group, base_output_dir).generate }
        end
      end

      attr_accessor :group_metadata, :base_output_dir

      def initialize(group_metadata, base_output_dir)
        self.group_metadata = group_metadata
        self.base_output_dir = base_output_dir
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'group.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        "#{class_name.underscore}.rb"
      end

      def base_metadata_file_name
        "metadata.yml"
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}Group"
      end

      def module_name
        "DaVinciPDEXPlanNet#{group_metadata.reformatted_version.upcase}"
      end

      def title
        group_metadata.title
      end

      def short_description
        group_metadata.short_description
      end

      def output_file_name
        File.join(base_output_dir, base_output_file_name)
      end

      def metadata_file_name
        File.join(base_output_dir, profile_identifier, base_metadata_file_name)
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def group_id
        "davinci_pdex_plan_net_#{group_metadata.reformatted_version}_#{profile_identifier}"
      end

      def resource_type
        group_metadata.resource
      end

      def search_validation_resource_type
        "#{resource_type} resources"
      end

      def profile_name
        group_metadata.profile_name
      end

      def profile_url
        group_metadata.profile_url
      end

      def optional?
        false #No Optional groups in Plan Net
      end

      def generate
#        add_special_tests
        File.open(output_file_name, 'w') { |f| f.write(output) }
        group_metadata.id = group_id
        group_metadata.file_name = base_output_file_name
        File.open(metadata_file_name, 'w') { |f| f.write(YAML.dump(group_metadata.to_hash)) }
      end

      def add_special_tests
        return if group_metadata.reformatted_version == 'v311'
      end

      def test_id_list
        @test_id_list ||=
          group_metadata.tests.map { |test| test[:id] }
      end

      def test_file_list
        @test_file_list ||=
          group_metadata.tests.map do |test|
            name_without_suffix = test[:file_name].delete_suffix('.rb')
            name_without_suffix.start_with?('..') ? name_without_suffix : "#{profile_identifier}/#{name_without_suffix}"
          end
      end

      def required_searches
        group_metadata.searches.select { |search| search[:expectation] == 'SHALL' }
      end

      def search_param_name_string
        required_searches
          .map { |search| search[:names].join(' + ') }
          .map { |names| "* #{names}" }
          .join("\n")
      end

      def include_param_name_string
        group_metadata.include_params
          .map { |names| "* #{names}" }
          .join("\n")
      end

      def revinclude_param_name_string
        group_metadata.revincludes
          .map { |names| "* #{names}" }
          .join("\n")
      end

      def search_description
        return '' if required_searches.blank?

        <<~SEARCH_DESCRIPTION
        
        ## Searching
        This test sequence will perform each required search associated
        with this resource. This sequence will perform searches with the
        following parameters:

        #{search_param_name_string}

        ### Search Parameters
        The first search uses the selected #{profile_name}(s) from the prior launch
        sequence. Any subsequent searches will look for its parameter values
        from the results of the first search. For example, the `identifier`
        search in the #{profile_name} sequence is performed by looking for an existing
        `#{resource_type}.identifier` value from an instance identified during
        the instance gathering step. If a value cannot be found this way, the search is skipped.

        ### Search Validation
        Inferno will retrieve up to the first 20 bundle pages of the reply for
        #{search_validation_resource_type}. Each of
        these resources is then checked to see if it matches the searched
        parameters in accordance with [FHIR search
        guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
        for example, if a #{profile_name} search for `#{required_searches.first[:names].first}=X`
        returns a #{profile_name} where `#{required_searches.first[:names].first}!=X`

        SEARCH_DESCRIPTION
      end

      def include_description
        return '' if group_metadata.include_params.blank?

        <<~INCLUDE_DESCRIPTION
        ## _include Requirement Testing
        This test sequence will perform each required _include search associated
        with this resource. This sequence will perform searches with the
        following includes:

        #{include_param_name_string}

        All _include searches will look for candidate IDs from the results of 
        instance gathering.  Each search will use a #{profile_name} ID and the include parameter.
        The return is scanned to find any of the expected additional resource.

        INCLUDE_DESCRIPTION
      end

      def revinclude_description
        return '' if group_metadata.revincludes.blank?

        <<~REVINCLUDE_DESCRIPTION
        ## _revinclude Requirement Testing
        This test sequence will perform each required _revinclude search associated
        with this resource. This sequence will perform searches with the
        following includes:

        #{revinclude_param_name_string}

        All _revinclude searches will look for candidate IDs from the results of 
        instance gathering _only_ if tests are ran from the suite level.  Each search 
        will use a #{profile_name} ID that is referenced by an instance of the revincluded resource
        and the revinclude parameter. The return is scanned to find any of the expected additional resource.

        If running from the profile level, input boxes are provided for these tests upon test start.

        REVINCLUDE_DESCRIPTION
      end

      def description
        <<~DESCRIPTION
        # Background

        The #{title} sequence verifies that the system under test is
        able to provide correct responses for #{resource_type} queries. These queries
        must return resources conforming to the #{profile_name} profile as
        specified in the Plan Net #{group_metadata.version} Implementation Guide.

        # Testing Methodology
        
        ## Instance Gathering

        Inferno will first identify and obtain a set of instances to use for the rest
        of the tests, requiring at least one instances to be identified for the test to pass. 
        Instances to gather are indentified in two ways. One or both will be used,
        depending on user input.

        ### Parameterless searches 
        Instances can be gathered using a query requesting all instances of #{resource_type} 
        (e.g., `GET [FHIR Endpoint]/#{resource_type}`). #{SpecialCases.has_parameterless_filter?(profile_name) ? SpecialCases.parameterless_filter_description(profile_name) : "" }Gathering through this method is controlled 
        by the following input fields (used for all profiles):
        - _Use parameterless searches to identify instances?_: 
          parameterless searches can be disabled using this input field if, for example, 
          the server under test does not support them, or not all instances on the server 
          should be expected to conform to Plan Net profiles. In this case the user **MUST**
          provide specific instance ids to gather.
        - _Maximum number of instances to gather using parameterless searches_: sets an upper 
          bound on the number of instances Inferno will gather from parameterless searches.
        - _Maximum pages of results to consider when using parameterless searches_: sets an upper bound 
          on the number of pages of search results Inferno will load when gathering instances 
          using parameterless searches.
        
        ### User-provided instance ids
        
        If ids are listed in the _Ids of instances of #{profile_name}_ optional input field, 
        they will be read and included in the set of gathered instances.

        #{search_description}
        #{include_description}
        #{revinclude_description}

        ## Must Support
        Each profile contains elements marked as "must support". This test
        sequence expects to see each of these elements populated at least once. If at
        least one cannot be found, the test will fail. The test will look
        through the #{profile_name} instances identified during instance gathering
        for these elements.

        ## Profile Validation
        Each resource identified during instance gathering is expected to conform to
        the [#{profile_name}](#{profile_url}). Each element is checked against
        teminology binding and cardinality requirements.

        Elements with a required binding are validated against their bound
        ValueSet. If the code/system in the element is not part of the ValueSet,
        then the test will fail.

        ## Reference Validation
        At least one instance of each external reference in elements marked as
        "must support" within the resources provided by the system must resolve.
        The test will attempt to read each reference found and will fail if no
        read succeeds.
        DESCRIPTION
      end
    end
  end
end
