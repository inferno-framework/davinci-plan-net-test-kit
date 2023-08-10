require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationRevincludeOrganizationaffiliationLocationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns OrganizationAffiliation resources from Location search by _revinclude=OrganizationAffiliation:location'
      description %(
        A server SHALL be capable of supporting _revIncludes for OrganizationAffiliation:location.

        This test will perform a search by _revinclude=OrganizationAffiliation:location and
        will pass if a OrganizationAffiliation resource is found in the response.
      )

      id :us_core_v110_location_revinclude_OrganizationAffiliation_location_search_test
  
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          revinclude_param: 'OrganizationAffiliation:location'
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
        scratch[:revinclude_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
