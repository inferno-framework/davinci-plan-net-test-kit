require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class LocationReverseChainInsurancePlanCoverageAreaOwnedBySearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server capable of reverse chaining through InsurancePlan\'s owned-by element'
      description %(
        Test will perform a search using the reverse chaining parameter 
        _has:InsurancePlan:coverage-area:owned-by
        using a value from either a previously identified InsurancePlan when 
        run from the suite level, or the "\'owned-by\' value from an InsurancePlan 
        instance with \'coverage-area\' populated" input when run at the group level. To validate the 
        returned instances, the test will perform a search 
        on the InsurancePlan resource type using the same owned-by search 
        parameter and value and check that the instances returned by the tested search are all referenced
        by the coverage-area element of instances returned by the additional search.
      )
      
      id :davinci_plan_net_v110_location_reverse_chain_insurance_plan_coverage_area_owned_by_search_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@22'

      input :insurance_plan_coverage_area_owned_by_input,
        title: '\'owned-by\' value from an InsurancePlan instance with \'coverage-area\' populated',
        description: 'Single value from the \'owned-by\' element of an InsurancePlan
        on an instance that also references a Location instance in its \'coverage-area\' element to be used for test 
        \'Server capable of reverse chaining through InsurancePlan\'s owned-by element\' when run at the group level.',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          input_name: 'insurance_plan_coverage_area_owned_by_input',
          reverse_chain_param: 'owned-by',
          reverse_chain_target: 'coverage-area',
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
        run_reverse_chain_search_test
      end
    end
  end
end
