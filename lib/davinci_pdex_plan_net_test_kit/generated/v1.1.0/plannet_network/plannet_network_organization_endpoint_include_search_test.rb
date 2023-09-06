require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PlannetNetworkOrganizationEndpointIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Endpoint resources from Organization search by _include=Organization:endpoint'
      description %(
        A server SHALL be capable of supporting _includes for Organization:endpoint.

        This test will perform a search by _include=Organization:endpoint and
        will pass if a Endpoint resource is found in the response.
      )

      id :davinci_plan_net_v110_plannet_network_organization_endpoint_include_search_test
      input :organization_endpoint_input,
        title: 'IDs of Organization that have Endpoint reference(s)',
        description: 'Comma separated list of Organization IDs that reference by a Endpoint',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'organization_endpoint_input',
          include_param: 'Organization:endpoint',
          additional_resource_type: 'Endpoint'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.include_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'Endpoint', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:plannet_network_resources] ||= {}
      end

      def scratch_include_resources
        scratch[:endpoint_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end