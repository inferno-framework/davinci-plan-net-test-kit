require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class NetworkRevincludePractitionerRoleNetworkSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns PractitionerRole resources from Organization search with _revinclude=PractitionerRole:network'
      description %(
        A server SHALL be capable of supporting searches _revincludes on search parameter PractitionerRole:network.

        This test will perform a search on Organization with _revinclude=PractitionerRole:network and the '_id'
        search parameter using an id previously identified during a suite level run or an id provided
        in the "Organization instance ids referenced in PractitionerRole.network" input if run at the group level.
        The test will pass if at least one PractitionerRole resource found in the response
        and each instance that does includes a reference to the Organization with the searched id.
      )

      id :davinci_plan_net_v110_revinclude_network_practitioner_role_network_search_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@28'

      input :practitioner_role_network_input,
        title: 'Organization instance ids referenced in PractitionerRole.network',
        description: %(Comma separated list of Organization instance ids that are referenced by a PractitionerRole
        instance in its network element. Used for test "Server returns PractitionerRole resources from Organization search with _revinclude=PractitionerRole:network"
        when run at the group level.),
        optional: true
        
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'practitioner_role_network_input',
          revinclude_param: 'PractitionerRole:network',
          rev_param_sp: 'network',
          additional_resource_type: 'PractitionerRole'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'practitioner_role', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:network_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
