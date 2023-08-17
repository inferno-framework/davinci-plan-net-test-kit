require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationAffiliationOrganizationaffiliationEndpointIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Endpoint resources from OrganizationAffiliation search by _include=OrganizationAffiliation:endpoint'
      description %(
        A server SHALL be capable of supporting _includes for OrganizationAffiliation:endpoint.

        This test will perform a search by _include=OrganizationAffiliation:endpoint and
        will pass if a Endpoint resource is found in the response.
      )

      id :davinci_plan_net_v110_v110_organization_affiliation_organizationaffiliation_endpoint_include_search_test
      input :organizationaffiliation_endpoint_input,
        title: 'IDs of OrganizationAffiliation that have Endpoint reference(s)',
        description: 'Comma separated list of OrganizationAffiliation IDs that reference by a Endpoint'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'OrganizationAffiliation',
          search_param_names: [],
          input_name: 'organizationaffiliation_endpoint_input',
          include_param: 'OrganizationAffiliation:endpoint',
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
        scratch[:organization_affiliation_resources] ||= {}
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