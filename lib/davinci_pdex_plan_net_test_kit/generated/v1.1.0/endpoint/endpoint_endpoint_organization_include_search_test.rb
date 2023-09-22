require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class EndpointEndpointOrganizationIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Organization resources from Endpoint search with _include=Endpoint:organization'
      description %(
        A server SHALL be capable of supporting _includes for Endpoint:organization.

        This test will perform a search with _include=Endpoint:organization and
        will pass if a Organization resource is found in the response.
      )

      id :davinci_plan_net_v110_endpoint_endpoint_organization_include_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Endpoint',
          search_param_names: [],
          include_param: 'Endpoint:organization',
          inc_param_sp: 'organization',
          additional_resource_type: 'Organization'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.include_metadata
        @include_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'Organization', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:endpoint_resources] ||= {}
      end

      def scratch_include_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end