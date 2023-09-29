require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class InsurancePlanIncludeInsurancePlanCoverageAreaSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Location resources from InsurancePlan search with _include=InsurancePlan:coverage-area'
      description %(
        A server SHALL be capable of supporting _includes for InsurancePlan:coverage-area.

        This test will perform a search with _include=InsurancePlan:coverage-area and
        will pass if a Location resource is found in the response.
      )

      id :davinci_plan_net_v110_include_insurance_plan_insurance_plan_coverage_area_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'InsurancePlan',
          search_param_names: [],
          include_param: 'InsurancePlan:coverage-area',
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
        scratch[:insurance_plan_resources] ||= {}
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