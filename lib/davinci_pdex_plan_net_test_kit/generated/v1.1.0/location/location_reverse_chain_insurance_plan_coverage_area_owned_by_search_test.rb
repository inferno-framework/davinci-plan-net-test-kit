require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationReverseChainInsurancePlanCoverageAreaOwnedBySearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server capable of reverse chaining through InsurancePlan\'s owned-by field'
      description %(
        A server SHALL support reverse chaining.

        Test will use the query _has:InsurancePlan:coverage-area:owned-by to test
        the server for reverse chaining capability.  This test does not validate returned resources at this time.
      )
      
      id :davinci_plan_net_v110_location_reverse_chain_insurance_plan_coverage_area_owned_by_search_test
      input :insurance_plan_coverage_area_owned_by_input,
        title: 'owned-by field value for InsurancePlan',
        description: 'Value from the owned-by field of an InsurancePlan
        that also references a Location instance in its coverage-area field',
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
