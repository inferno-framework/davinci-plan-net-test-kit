require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationRevincludeHealthcareserviceLocationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns HealthcareService resources from Location search by _revinclude=HealthcareService:location'
      description %(
        A server SHALL be capable of supporting _revIncludes for HealthcareService:location.

        This test will perform a search by _revinclude=HealthcareService:location and
        will pass if a HealthcareService resource is found in the response.
      )

      id :us_core_v110_location_revinclude_HealthcareService_location_search_test
  
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          revinclude_param: 'HealthcareService:location'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'HealthcareService', 'metadata.yml'), aliases: true))
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
