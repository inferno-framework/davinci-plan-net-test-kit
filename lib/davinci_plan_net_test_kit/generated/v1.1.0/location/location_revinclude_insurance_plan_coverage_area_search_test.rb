require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class LocationRevincludeInsurancePlanCoverageAreaSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns InsurancePlan resources from Location search with _revinclude=InsurancePlan:coverage-area'
      description %(
        A server SHALL be capable of supporting searches _revIncludes on search parameter InsurancePlan:coverage-area.

        This test will perform a search on Location with _revinclude=InsurancePlan:coverage-area and the '_id'
        search parameter using an id previoiusly identified when the whole test suite is run or an id provided
        in the "Location instance ids referenced in InsurancePlan.coverage-area" input if run at the group level.
        The test will pass if at least one InsurancePlan resource found in the response
        and each instance that does includes a reference to the Location with the searched id.
      )

      id :davinci_plan_net_v110_revinclude_location_insurance_plan_coverage_area_search_test
      input :insurance_plan_coverage_area_input,
        title: 'Location instance ids referenced in InsurancePlan.coverage-area',
        description: %(Comma separated list of Location instance ids that are referenced by an InsurancePlan
        instance in its coverage-area element. Used for test "Server returns InsurancePlan resources from Location search with _revinclude=InsurancePlan:coverage-area"
        when run at the group level.),
        optional: true
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          input_name: 'insurance_plan_coverage_area_input',
          revinclude_param: 'InsurancePlan:coverage-area',
          rev_param_sp: 'coverage-area',
          additional_resource_type: 'InsurancePlan'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'insurance_plan', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:insurance_plan_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
