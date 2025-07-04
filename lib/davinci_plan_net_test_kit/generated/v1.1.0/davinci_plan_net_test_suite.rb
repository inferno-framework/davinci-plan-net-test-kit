require_relative '../../version'
require_relative '../../custom_groups/v1.1.0/capability_statement_group'
require_relative 'endpoint_group'
require_relative 'insurance_plan_group'
require_relative 'org_affil_group'
require_relative 'practitioner_role_group'
require_relative 'practitioner_group'
require_relative 'healthcare_service_group'
require_relative 'location_group'
require_relative 'network_group'
require_relative 'organization_group'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetServerV110
    class DaVinciPlanNetServerTestSuite < Inferno::TestSuite
      title 'DaVinci Plan Net v1.1.0 Server Test Suite'
      description %(
        The Plan Net Test Kit tests servers for their conformance to the [Plan Net
        Implementation Guide](https://hl7.org/fhir/us/davinci-pdex-plan-net/STU1.1).

        ## Scope

        These tests are a **DRAFT** intended to allow Plan Net server implementers to perform
        preliminary checks of their servers against Plan Net IG requirements and [provide
        feedback](https://github.com/inferno-framework/davinci-plan-net-test-kit/issues)
        to ONC on the tests. Future versions of these tests may validate other
        requirements and may change the test validation logic.

        ## Test Methodology

        Inferno will act as a client and make a series of requests to the
        server under test. The responses will be checked for conformance to the Plan
        Net IG requirements individually and used in aggregate to determine whether
        required features and functionality are present.

        HL7® FHIR® resources are validated with the Java validator using
        `tx.fhir.org` as the terminology server.

        ## Running the Tests

        ### Quick Start

        The tests are designed to be runnable with a single input from the user:
        the base FHIR URL of the server under test. To run in this mode:
        1. Click the `RUN ALL TESTS` button in the upper right
        2. Provide the URL for the server in the first "FHIR Endpoint (required)" input
        3. Click the `Submit` button in the lower right of the input display
        4. Wait for Inferno to run the tests (will take several minutes)
        5. Expand tests with failures to determine the reason

        If you would like to try out the tests but don't have a Plan Net server implementation,
        you can use the publicly available reference implementation available at URL
        https://plan-net-ri.davinci.hl7.org/fhir. Select this endpoint by using that URL as the
        "FHIR Endpoint (required)" input or prepopulating it by selecting the
        `Da Vinci Plan Net Reference Server` preset in the upper left. Note that this
        system is not currently expected to pass all of the tests.

        The feedback provided may require
        - Configuration updates (see *Test Configuration Details* below) to better guide Inferno's test execution.
        - Additional data within the system under test, e.g., to demonstrate all Must Support elements.
        - Fixes to the system under test.

        Note that this mode requires that the server support parameterless searches against
        Plan Net resource types (e.g., `GET [FHIR Endpoint]/InsurancePlan`), which are not required
        by the Plan Net IG. If your server does not support these searches, or some returned instances
        will not conform to Plan Net profiles, see the *Instance Gathering* section under
        *Test Configuration Details* below for how to disable these searches and direct the tests
        toward specific instances of each profile instead.

        ### Running Groups Individually

        Each test group listed on the left can be run individually using the `RUN TESTS`
        button in the upper right of the group page. However, note that running
        them individually requires additional inputs so that Inferno can find appropriate values for searches
        (see *Determination of Search Values When Running Single Groups* below for details).

        ## Test Configuration Details

        The details provided here supplement the documentation of individual inputs in the input dialog
        that appears when initiating a test run.

        ### Authentication

        The Plan Net IG requires that "A conformant Plan-Net service SHALL NOT
        require a directory mobile application to send consumer identifying information
        in order to query content." A simple way to ensure this is to not require authentication,
        which is safe because the information in scope does not include PHI. Thus, the
        tests do not send authentication details by default.

        If a server under test requires authentication information to be sent, an access token
        may be provided using the "OAuth Credentials - Access Token" input. When populated,
        requests to the server will include an HTTP header of the form `Authorization: Bearer [access token]`.

        ### Instance Gathering

        Inferno needs to identify instances of each profile to use to validate conformance to
        structural and search API requirements. Inferno will use one or a combination of the
        following two approaches as directed by the inputs.

        #### Parameterless searches (default)

        Inferno will use a search against the base resource type without any search
        parameters (`GET [FHIR Endpoint]/[Resource Type]`) to identify instances of each profile.
        This behavior can be controlled using the following inputs:
        - "Use parameterless searches to identify instances?": if the server under test does not support
          parameterless searches, this can be set to `No` to disable parameterless searches.
        - "Maximum number of instances to gather using parameterless searches (required)" and
          "Maximum pages of results to consider when using parameterless searches (required)": if fewer
          instances (e.g., to improve performance) or more instances (e.g., to improve Must Support
          element coverage) should be gathered, these inputs can be adjusted to tune the number
          of instances that Inferno will gather using parameterless searches.

        #### Specific instance ids

        Inputs of the form "ids of [profile] instances" can be used by the user to specify particular
        instances for Inferno to gather for use in testing. Inferno will perform a read on each provided id
        to gather the instances. When parameterless searches are not used, all inputs of this form must be populated.
        When instance ids are provided in addition to parameterless searches, instances provided by the user
        are prioritized for use in determining search values for search tests.

        ### Determination of Search Values When Running Single Groups

        Validation of search parameters requires Inferno to identify values that are expected
        to return instances. By default, Inferno does this by examining gathered instances of each profile
        to identify search values that should return results when performed against the server under
        test. For `_revinclude` and reverse chaining tests, Inferno needs access to instances of other profiles
        in order to determine appropriate search values. When test groups are run individually, Inferno will not
        have access to instances identified while running other groups. Thus, when running at the group level,
        two additional inputs are required to allow the tests to identify appropriate search values:
        - "[target profile] instance ids referenced in [referencing profile].[reference element]":
          used by `_revinclude` tests on [target profile] when run as a group to identify
          instances of the [target profile] that have instances of [referencing profile] that reference it.
        - "'[constraining element]' value from a [referencing profile] instance with '[reference element]' populated": used by reverse chaining tests
          on the [target profile] referenced in the [reference element] element when run as a single group
          to identify the value to use when performing the reverse chain search.
      )

      VALIDATION_MESSAGE_FILTERS = [
        %r{Sub-extension url 'introspect' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        %r{Sub-extension url 'revoke' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        /Observation\.effective\.ofType\(Period\): .*us-core-1:/, # Invalid invariant in US Core v3.1.1
        /\A\S+: \S+: URL value '.*' does not resolve/,
      ].freeze

      VERSION_SPECIFIC_MESSAGE_FILTERS = [].freeze

      def self.metadata
        @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
            Generator::GroupMetadata.new(raw_metadata)
          end
      end

      id :davinci_plan_net_server_v110

      requirement_sets(
        {
          identifier: 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0',
          title: 'DaVinci PDEX Plan Net',
          actor: 'Server'
        }
      )

      fhir_resource_validator do
        igs 'hl7.fhir.us.davinci-pdex-plan-net#1.1.0'

        message_filters = VALIDATION_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

        exclude_message do |message|

          message_filters.any? { |filter| filter.match? message.message }
        end

        perform_additional_validation do |resource, profile_url|
          ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
        end
      end

      links [
        {
          label: 'Report Issue',
          url: 'https://github.com/inferno-framework/davinci-plan-net-test-kit/issues'
        },
        {
          label: 'Open Source',
          url: 'https://github.com/inferno-framework/davinci-plan-net-test-kit'
        },
        {
          label: 'Download',
          url: 'https://github.com/inferno-framework/davinci-plan-net-test-kit/releases'
        },
        {
          label: 'Implementation Guide',
          url: 'https://hl7.org/fhir/us/davinci-pdex-plan-net/STU1.1'
        }
      ]

      input :url,
        title: 'FHIR Endpoint',
        description: 'URL of the FHIR endpoint'
      input :smart_auth_info,
        title: 'OAuth Credentials',
        type: :auth_info,
        optional: true,
        options: {
          mode: 'access'
        }
      input :no_param_search,
        title: 'Use parameterless searches to identify instances?',
        type: 'radio',
        options: {
            list_options: [
              {
                label: 'Yes',
                value: 'true'
              },
              {
                label: 'No',
                value: 'false'
              }
            ]
          },
        default: 'true',
        description: 'If `Yes`, Inferno will gather instances of each profile using searches of the form `GET [FHIR Endpoint]/[resource type]`. If searches of this form are not supported or some instances on the server will not be expected to conform to Plan Net profiles, select `No` and enter instance ids of each profile in the "ids of [profile] instances" inputs.'
      input :max_instances,
        title: 'Maximum number of instances to gather using parameterless searches',
        default: '200',
        description: 'Only used with parameterless searches. A higher number will gather more instances for the tests, if they are available. The test will stop looking when the page limit has been reached.'
      input :max_pages,
        title: 'Maximum pages of results to consider when using parameterless searches',
        default: '20',
        description: 'Only used with parameterless searches. A higher number will gather more instances for the tests, if they are available. The test will not consider further pages once the maximum number of instances has been reached.'

      fhir_client do
        url :url
        auth_info :smart_auth_info
      end

      group from: :davinci_plan_net_v110_capability_statement
  
      group from: :davinci_plan_net_v110_endpoint
      group from: :davinci_plan_net_v110_insurance_plan
      group from: :davinci_plan_net_v110_org_affil
      group from: :davinci_plan_net_v110_practitioner_role
      group from: :davinci_plan_net_v110_practitioner
      group from: :davinci_plan_net_v110_healthcare_service
      group from: :davinci_plan_net_v110_location
      group from: :davinci_plan_net_v110_network
      group from: :davinci_plan_net_v110_organization
    end
  end
end
