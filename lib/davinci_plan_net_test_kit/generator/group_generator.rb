require_relative 'naming'
require_relative 'special_cases'

module DaVinciPlanNetTestKit
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
        "DaVinciPlanNet#{group_metadata.reformatted_version.upcase}"
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
        "davinci_plan_net_#{group_metadata.reformatted_version}_#{profile_identifier}"
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

      def chain_requirement_list_for_param(search_parameter)
        sym = search_parameter.class != Symbol ? search_parameter.to_sym : search_parameter
        req_list = group_metadata.search_definitions[sym][:chain].nil? ? [] : group_metadata.search_definitions[sym][:chain]
        req_list
      end

      def any_chain_requirements?
        !chainable_parameters.empty?
      end

      def chainable_parameters
        chainable_params = group_metadata.search_definitions.keys.reject do |search_parameter| 
          req_list = chain_requirement_list_for_param(search_parameter)  
          req_list.nil? || req_list.empty?
        end
        chainable_params
      end

      def generate
#       add_special_tests
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

      def forward_chain_table
        chain_table = "| Search Parameters | Chain Requirements |\n| :---: | :---: |\n"
        # Iterate through the chain requirements and add to table
        chainable_parameters.each do |chain_param|
          chain_requirement_list = chain_requirement_list_for_param(chain_param).map { |chain| chain[:chain]}
          chain_table += "| #{chain_param} | #{chain_requirement_list.join(', ')} |\n"
        end
        
        chain_table
      end

      def reverse_chain_string
        # Placeholder until we have a more clear way of inferring reverse requirements
        examples = File.read('lib/davinci_plan_net_test_kit/custom_groups/reverse_chain_tests/examples.json')
        examples_hash = JSON.parse(examples)[Naming.upper_camel_case_for_profile(group_metadata)]
          .map { |test_example| "* #{test_example['source_resource']}:#{test_example['target_param']}:#{test_example['constraining_param']}" }
          .join("\n")
      end

      def search_description
        return '' if required_searches.blank?

        <<~SEARCH_DESCRIPTION
        
        ## Searching
        This test sequence will perform a search with each required search parameter
        associated with this resource individually. Searches with the
        following parameters will be performed:

        #{search_param_name_string}

        ### Search Parameters
        Each search will look for its parameter values
        from the results of the instance gathering step. For example, for a search using
        the `identifier` search parameter, the test searches the gathered instances
        for one with the `identifier` element populated and then uses that value
        as the queried `identifier` value. If a value cannot be found this way, 
        the search test is skipped for that search parameter.

        ### Search Validation
        Inferno will retrieve all bundle pages of the reply for
        #{search_validation_resource_type}. Each of the returned instances
        is then checked to see if it matches the searched
        parameters in accordance with [FHIR search
        guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
        for example, if a #{profile_name} search for `#{required_searches.first[:names].first}=X`
        returns a #{profile_name} instance where `#{required_searches.first[:names].first}!=X`

        SEARCH_DESCRIPTION
      end

      def include_description
        return '' if group_metadata.include_params.blank?

        <<~INCLUDE_DESCRIPTION
        ## _include Requirement Testing
        This test sequence will perform a search with each required _include search 
        parameter associated with this profile. This sequence will perform searches with the
        following includes:

        #{include_param_name_string}

        Each _include search will look for a candidate id that has the target reference element
        populated from the results of instance gathering.  Each search will use the identified 
        #{profile_name} id and the include parameter.
        The returned instances are checked to ensure that any instances of the included
        type are referenced by returned instances of the searched resource type.

        INCLUDE_DESCRIPTION
      end

      def revinclude_description
        return '' if group_metadata.revincludes.blank?

        <<~REVINCLUDE_DESCRIPTION
        ## _revinclude Requirement Testing
        This test sequence will perform a search with each required _revinclude search 
        parameter associated with this resource. This sequence will perform searches with the
        following revincludes:

        #{revinclude_param_name_string}

        All _revinclude searches will look for candidate ids from the results of 
        instance gathering _only_ if tests are ran from the suite level.  Each search 
        will use a #{profile_name} id that is referenced by an instance of the revincluded resource
        in the element that is the target of the revinclude search parameter. The returned instances 
        are checked to ensure that any 
        instances of the revincluded type reference returned instances of the searched resource type.

        If running from the group level, inputs of the form 
        "#{resource_type} instance ids referenced in \[referencing profile\].\[referencing element\]"
        are provided for these tests. Enter ids of the #{resource_type} profile that
        are referenced by the \[referencing element\] of an instance of the \[referencing profile\].

        REVINCLUDE_DESCRIPTION
      end

      def forward_chain_description
        return '' if !any_chain_requirements?

        <<~FORWARD_CHAINING_DESCRIPTION
        ## Forward Chaining Requirement Testing
        This test sequence will perform a search with each required combination of forward chaining 
        search parameters. This sequence will perform searches with the following chaining parameters:

        #{forward_chain_table}

        All forward chain searches will look for candidate instances of the resource being chained through
        from the results of previously run _include tests.  Candidates are chosen from previously returned
        instances that have the chain parameter element filled.  Each search test will use one of these values
        to build the requests for the test.  The test will be skipped if no candidates can be found.

        The test will first create and execute the forward chaining request.
        The test will then perform a basic search test on the resource being chained through,
        using the same value in the previous request.  Each resource returned in the first
        request will then be checked, validating that the element being chained through is populated by
        the id of _any_ of the resources returned by the second request.
        
        FORWARD_CHAINING_DESCRIPTION
      end

      def reverse_chain_description
        return '' if !test_id_list.any? {|test_id| test_id.include?('reverse_chain')}
        <<~REVERSE_CHAINING_DESCRIPTION
        ## Reverse Chaining Requirement Testing
        This test sequence will perform a search with each required combination of reverse chaining 
        search parameters, including the following combinations:

        #{reverse_chain_string}

        All reverse chain searches will look for candidate instances from the results of 
        previous tests _only_ if tests are ran from the suite level.  Candidates are 
        selected by checking they have both the second (reference element) and third (constraining element) elements
        populated. The search value will be taken from the constraining element on the
        identified candidate.

        If running from the profile level, inputs of the form 
        "\'\[constraining element\]\' value from a \[source resource type\] instance with \'\[reference element\]\' populated"
        are provided for these tests upon test start. Enter a value from the \[constraining element\] element
        of an instance of a \[source resource type\] resource that also contains a reference to
        the tested #{resource_type} in its \[reference element\] element. The input will
        be used as the search value.

        The test will first create and execute a request with the chain parameter.
        The test will then perform a search against the \[source resource type\] with
        the \[constraining\] SeachParameter using the same search value.  Each resource returned in the first
        request will then be checked, validating that the ids of those resources are also referenced
        by _any_ of the resources returned by the second request in its \[reference element\] element.
        
        REVERSE_CHAINING_DESCRIPTION
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
        of the tests, requiring at least one instance to be identified for the test to pass. 
        Instances to gather are indentified in two ways. One or both will be used,
        depending on user input.

        ### Parameterless searches 
        Instances can be gathered using a query requesting all instances of #{resource_type} 
        (e.g., `GET [FHIR Endpoint]/#{resource_type}`). #{SpecialCases.has_parameterless_filter?(profile_name) ? SpecialCases.parameterless_filter_description(profile_name) : "" }
        Gathering through this method is controlled by the following inputs (used for all profiles):
        - "Use parameterless searches to identify instances?": 
          parameterless searches can be disabled using this input if, for example, 
          the server under test does not support them, or not all instances on the server 
          should be expected to conform to Plan Net profiles. In this case the user **MUST**
          provide specific instance ids to gather.
        - "Maximum number of instances to gather using parameterless searches": sets an upper 
          bound on the number of instances Inferno will gather from parameterless searches.
        - "Maximum pages of results to consider when using parameterless searches": sets an upper bound 
          on the number of pages of search results Inferno will load when gathering instances 
          using parameterless searches.
        
        ### User-provided instance ids
        
        If ids are listed in the "ids of #{profile_name} instances" optional input, 
        they will be read and included at the start of the set of gathered instances.

        #{search_description}
        #{include_description}
        #{revinclude_description}
        #{forward_chain_description}
        #{reverse_chain_description}

        ## Profile Validation
        Each resource identified during instance gathering and other queries run during this test sequence
        is expected to conform to the [#{profile_name}](#{group_metadata.versioned_profile_url}). Each element is checked 
        by the HL7 Validator against terminology binding and cardinality requirements. Elements with a 
        required binding are validated against their bound ValueSet. If the code/system in the element 
        is not part of the ValueSet, then the test will fail.

        ## Must Support
        Each profile contains elements marked as "must support". This test
        sequence expects to see each of these elements populated at least once. 
        The test will look through the #{profile_name} instances identified 
        during instance gathering and other queries run during this test sequence.
        If no populated instance can be found for any must support element, the test 
        will fail. 

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
