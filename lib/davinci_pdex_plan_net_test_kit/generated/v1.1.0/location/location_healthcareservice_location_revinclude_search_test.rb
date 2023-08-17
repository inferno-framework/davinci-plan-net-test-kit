require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationHealthcareserviceLocationRevincludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns HealthcareService resources from Location search by _revinclude=HealthcareService:location'
      description %(
        A server SHALL be capable of supporting _revIncludes for HealthcareService:location.

        This test will perform a search by _revinclude=HealthcareService:location and
        will pass if a HealthcareService resource is found in the response.
      )

      id :davinci_plan_net_v110_v110_location_healthcareservice_location_revinclude_search_test
      input :healthcareservice_location_input,
        title: 'HealthcareService referenced Location IDs',
        description: 'Comma separated list of Location  IDs that are referenced by a HealthcareService'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          input_name: 'healthcareservice_location_input',
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
        scratch[:healthcareservice_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
