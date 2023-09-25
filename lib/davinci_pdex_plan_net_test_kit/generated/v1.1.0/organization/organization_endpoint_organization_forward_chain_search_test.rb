require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationEndpointOrganizationForwardChainSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Organization that populate the organization field of a Endpoint instance
      through the search parameter endpoint'
      description %(
        A server SHALL be capable of supporting chaining for organization.

        This test will perform a search with organization and
        will pass if a organization resource is found in the response.
      )

      id :davinci_plan_net_v110_endpoint_organization_forward_chain_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
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
        scratch[:organization_resources] ||= {}
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