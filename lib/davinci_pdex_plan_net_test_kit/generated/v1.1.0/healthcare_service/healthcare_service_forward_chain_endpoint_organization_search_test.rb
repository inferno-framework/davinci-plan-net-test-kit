require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class HealthcareServiceForwardChainEndpointOrganizationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server capable of forward chaining with endpoint.organization'
      description %(
        A server SHALL be capable of supporting chaining for organization through the search parameter endpoint
        for the Healthcare_service profile.

        This test will perform a search with endpoint.organization and
        will pass if a HealthcareService resource is found in the response.
      )

      id :davinci_plan_net_v110_forward_chain_endpoint_organization_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'HealthcareService',
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
        scratch[:healthcare_service_resources] ||= {}
      end

      def scratch_chain_resources
        scratch[:endpoint_resources] ||= {}
      end

      run do
        run_forward_chain_search_test
      end
    end
  end
end