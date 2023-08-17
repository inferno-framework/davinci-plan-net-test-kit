require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationAffiliationOrganizationaffiliationParticipatingOrganizationIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Organization resources from OrganizationAffiliation search by _include=OrganizationAffiliation:participating-organization'
      description %(
        A server SHALL be capable of supporting _includes for OrganizationAffiliation:participating-organization.

        This test will perform a search by _include=OrganizationAffiliation:participating-organization and
        will pass if a Organization resource is found in the response.
      )

      id :davinci_plan_net_v110_v110_organization_affiliation_organizationaffiliation_participating_organization_include_search_test
      input :organizationaffiliation_participating_organization_input,
        title: 'IDs of OrganizationAffiliation that have Organization reference(s)',
        description: 'Comma separated list of OrganizationAffiliation IDs that reference by a Organization'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'OrganizationAffiliation',
          search_param_names: [],
          input_name: 'organizationaffiliation_participating_organization_input',
          include_param: 'OrganizationAffiliation:participating-organization',
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