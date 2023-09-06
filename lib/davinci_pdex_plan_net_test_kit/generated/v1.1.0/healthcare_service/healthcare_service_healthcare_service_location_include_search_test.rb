require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class HealthcareServiceHealthcareServiceLocationIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Location resources from HealthcareService search by _include=HealthcareService:location'
      description %(
        A server SHALL be capable of supporting _includes for HealthcareService:location.

        This test will perform a search by _include=HealthcareService:location and
        will pass if a Location resource is found in the response.
      )

      id :davinci_plan_net_v110_healthcare_service_healthcare_service_location_include_search_test
      input :healthcare_service_location_input,
        title: 'IDs of HealthcareService that have Location reference(s)',
        description: 'Comma separated list of HealthcareService IDs that reference by a Location',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'HealthcareService',
          search_param_names: [],
          input_name: 'healthcare_service_location_input',
          include_param: 'HealthcareService:location',
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
        scratch[:healthcare_service_resources] ||= {}
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