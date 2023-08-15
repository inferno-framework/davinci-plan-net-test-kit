require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PlannetOrganizationEndpointOrganizationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Endpoint resources from Organization search by _revinclude=Endpoint:organization'
      description %(
        A server SHALL be capable of supporting _revIncludes for Endpoint:organization.

        This test will perform a search by _revinclude=Endpoint:organization and
        will pass if a Endpoint resource is found in the response.
      )

      id :davinci_plan_net_v110_v110_plannet_organization_endpoint_organization_revinclude_search_test
  
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: ["_id"],
          revinclude_param: 'Endpoint:organization'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'Endpoint', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:plannet_organization_resources] ||= {}
      end

      def scratch_revinclude_resources
        scratch[:Endpoint_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
