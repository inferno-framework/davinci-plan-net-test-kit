require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrgAffilIncludeOrganizationAffiliationLocationSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns Location resources from OrganizationAffiliation search with _include=OrganizationAffiliation:location'
      description %(
        A server SHALL be capable of supporting _includes on search parameter OrganizationAffiliation:location.

        This test will perform a search on OrganizationAffiliation with _include=OrganizationAffiliation:location 
        and the '_id' search parameter using an id with a reference to a Location
        identified during instance gathering. The test will pass if at least one Location 
        resource is found in the response and each instance that does is referenced by a returned OrganizationAffiliation instance.
      )

      id :davinci_plan_net_v110_include_org_affil_organization_affiliation_location_search_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@27'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'OrganizationAffiliation',
          search_param_names: [],
          include_param: 'OrganizationAffiliation:location',
          inc_param_sp: 'location',
          additional_resource_type: 'Location'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'location', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:org_affil_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:location_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end