require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class InsurancePlanInsuranceplanCoverageAreaIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Location resources from InsurancePlan search by _include=InsurancePlan:coverage-area'
      description %(
        A server SHALL be capable of supporting _includes for InsurancePlan:coverage-area.

        This test will perform a search by _include=InsurancePlan:coverage-area and
        will pass if a Location resource is found in the response.
      )

      id :davinci_plan_net_v110_v110_insurance_plan_insuranceplan_coverage_area_include_search_test
      input :insuranceplan_coverage_area_input,
        title: 'IDs of InsurancePlan that have Location reference(s)',
        description: 'Comma separated list of InsurancePlan IDs that reference by a Location'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'InsurancePlan',
          search_param_names: [],
          input_name: 'insuranceplan_coverage_area_input',
          include_param: 'InsurancePlan:coverage-area',
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