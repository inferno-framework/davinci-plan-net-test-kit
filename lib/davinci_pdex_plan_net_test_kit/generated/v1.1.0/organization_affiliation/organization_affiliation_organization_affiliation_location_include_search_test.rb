require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationAffiliationOrganizationAffiliationLocationIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Location resources from OrganizationAffiliation search by _include=OrganizationAffiliation:location'
      description %(
        A server SHALL be capable of supporting _includes for OrganizationAffiliation:location.

        This test will perform a search by _include=OrganizationAffiliation:location and
        will pass if a Location resource is found in the response.
      )

      id :davinci_plan_net_v110_organization_affiliation_organization_affiliation_location_include_search_test
      input :organization_affiliation_location_input,
        title: 'IDs of OrganizationAffiliation that have Location reference(s)',
        description: 'Comma separated list of OrganizationAffiliation IDs that reference by a Location',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'OrganizationAffiliation',
          search_param_names: [],
          input_name: 'organization_affiliation_location_input',
          include_param: 'OrganizationAffiliation:location',
          inc_param_sp: 'location',
          additional_resource_type: 'Location'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.include_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'Location', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_affiliation_resources] ||= {}
      end

      def scratch_include_resources
        scratch[:location_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end