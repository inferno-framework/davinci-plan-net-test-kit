require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationOrganizationAffiliationLocationRevincludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns OrganizationAffiliation resources from Location search by _revinclude=OrganizationAffiliation:location'
      description %(
        A server SHALL be capable of supporting _revIncludes for OrganizationAffiliation:location.

        This test will perform a search by _revinclude=OrganizationAffiliation:location and
        will pass if a OrganizationAffiliation resource is found in the response.
      )

      id :davinci_plan_net_v110_location_organization_affiliation_location_revinclude_search_test
      input :organization_affiliation_location_input,
        title: 'OrganizationAffiliation referenced Location IDs',
        description: 'Comma separated list of Location  IDs that are referenced by a OrganizationAffiliation',
        optional: true
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          input_name: 'organization_affiliation_location_input',
          revinclude_param: 'OrganizationAffiliation:location',
          rev_param_sp: 'location',
          additional_resource_type: 'OrganizationAffiliation'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'OrganizationAffiliation', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      def scratch_revinclude_resources
        scratch[:OrganizationAffiliation_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
