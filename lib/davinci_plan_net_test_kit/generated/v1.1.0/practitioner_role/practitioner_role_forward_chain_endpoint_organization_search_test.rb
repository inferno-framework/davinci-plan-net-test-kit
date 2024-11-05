require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class PractitionerRoleForwardChainEndpointOrganizationSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server capable of forward chaining with endpoint.organization'
      description %(
        A server SHALL be capable of supporting chaining for organization through the search parameter endpoint
        for the Practitioner_role profile.

        This test will perform a search with endpoint.organization using a value
        in the organization element on an instance found during _include tests executed
        previously during this sequence. To validate the returned instances, the test will perform a search 
        on the Endpoint resource type using the same organization search 
        parameter and value and check that this search contains any instances referenced through the 
        endpoint element of instances returned by the tested search.
      )

      id :davinci_plan_net_v110_forward_chain_practitioner_role_endpoint_organization_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'PractitionerRole',
          search_param_names: [],
          chain_param: 'organization',
          chain_param_base: 'endpoint',
          additional_resource_type: 'Endpoint'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'endpoint', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:endpoint_resources] ||= {}
      end

      run do
        run_forward_chain_search_test
      end
    end
  end
end