require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationAffiliationOrganizationAffiliationNetworkIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Organization resources from OrganizationAffiliation search by _include=OrganizationAffiliation:network'
      description %(
        A server SHALL be capable of supporting _includes for OrganizationAffiliation:network.

        This test will perform a search by _include=OrganizationAffiliation:network and
        will pass if a Organization resource is found in the response.
      )

      id :davinci_plan_net_v110_organization_affiliation_organization_affiliation_network_include_search_test
      input :organization_affiliation_network_input,
        title: 'IDs of OrganizationAffiliation that have Organization reference(s)',
        description: 'Comma separated list of OrganizationAffiliation IDs that reference by a Organization',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'OrganizationAffiliation',
          search_param_names: [],
          input_name: 'organization_affiliation_network_input',
          include_param: 'OrganizationAffiliation:network',
          additional_resource_type: 'Organization'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.include_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'Organization', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_affiliation_resources] ||= {}
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