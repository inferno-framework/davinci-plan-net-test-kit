require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class HealthcareServiceIncludeHealthcareServiceCoverageAreaSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns Location resources from HealthcareService search with _include=HealthcareService:coverage-area'
      description %(
        A server SHALL be capable of supporting _includes on search parameter HealthcareService:coverage-area.

        This test will perform a search on HealthcareService with _include=HealthcareService:coverage-area 
        and the '_id' search parameter using an id with a reference to a Location
        identified during instance gathering. The test will pass if at least one Location 
        resource is found in the response and each instance that does is referenced by a returned HealthcareService instance.
      )

      id :davinci_plan_net_v110_include_healthcare_service_healthcare_service_coverage_area_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'HealthcareService',
          search_param_names: [],
          include_param: 'HealthcareService:coverage-area',
          inc_param_sp: 'coverage-area',
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
        scratch[:healthcare_service_resources] ||= {}
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