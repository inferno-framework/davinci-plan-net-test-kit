require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class LocationRevincludeOrganizationAffiliationLocationSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns OrganizationAffiliation resources from Location search with _revinclude=OrganizationAffiliation:location'
      description %(
        A server SHALL be capable of supporting searches _revincludes on search parameter OrganizationAffiliation:location.

        This test will perform a search on Location with _revinclude=OrganizationAffiliation:location and the '_id'
        search parameter using an id previously identified during a suite level run or an id provided
        in the "Location instance ids referenced in OrganizationAffiliation.location" input if run at the group level.
        The test will pass if at least one OrganizationAffiliation resource found in the response
        and each instance that does includes a reference to the Location with the searched id.
      )

      id :davinci_plan_net_v110_revinclude_location_organization_affiliation_location_search_test
      input :organization_affiliation_location_input,
        title: 'Location instance ids referenced in OrganizationAffiliation.location',
        description: %(Comma separated list of Location instance ids that are referenced by an OrganizationAffiliation
        instance in its location element. Used for test "Server returns OrganizationAffiliation resources from Location search with _revinclude=OrganizationAffiliation:location"
        when run at the group level.),
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

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'org_affil', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:organization_affiliation_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
