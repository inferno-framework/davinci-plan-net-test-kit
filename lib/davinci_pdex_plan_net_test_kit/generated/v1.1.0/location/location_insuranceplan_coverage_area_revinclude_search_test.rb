require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationInsuranceplanCoverageAreaRevincludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns InsurancePlan resources from Location search by _revinclude=InsurancePlan:coverage-area'
      description %(
        A server SHALL be capable of supporting _revIncludes for InsurancePlan:coverage-area.

        This test will perform a search by _revinclude=InsurancePlan:coverage-area and
        will pass if a InsurancePlan resource is found in the response.
      )

      id :davinci_plan_net_v110_v110_location_insuranceplan_coverage_area_revinclude_search_test
      input :insuranceplan_coverage_area_input,
        title: 'InsurancePlan referenced Location IDs',
        description: 'Comma separated list of Location  IDs that are referenced by a InsurancePlan'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          input_name: 'insuranceplan_coverage_area_input',
          revinclude_param: 'InsurancePlan:coverage-area'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'InsurancePlan', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      def scratch_revinclude_resources
        scratch[:insuranceplan_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
