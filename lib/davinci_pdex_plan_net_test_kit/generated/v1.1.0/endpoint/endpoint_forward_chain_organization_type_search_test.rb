require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class EndpointForwardChainOrganizationTypeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server capable of forward chaining with organization.type'
      description %(
        A server SHALL be capable of supporting chaining for type through the search parameter organization
        for the Endpoint profile.

        This test will perform a search with organization.type and
        will pass if an Endpoint resource is found in the response.
      )

      id :davinci_plan_net_v110_forward_chain_organization_type_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Endpoint',
          search_param_names: [],
          chain_param: 'type',
          chain_param_base: 'organization',
          additional_resource_type: 'Organization'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'organization', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:endpoint_resources] ||= {}
      end

      def scratch_chain_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        run_forward_chain_search_test
      end
    end
  end
end