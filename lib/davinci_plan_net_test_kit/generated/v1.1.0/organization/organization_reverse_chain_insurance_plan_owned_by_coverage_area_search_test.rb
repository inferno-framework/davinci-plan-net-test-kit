require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationReverseChainInsurancePlanOwnedByCoverageAreaSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server capable of reverse chaining through InsurancePlan\'s coverage-area element'
      description %(
        Test will perform a search using the reverse chaining parameter 
        _has:InsurancePlan:owned-by:coverage-area
        using a value from either a previously identified InsurancePlan when 
        run from the suite level, or the "\'coverage-area\' value from an InsurancePlan 
        instance with \'owned-by\' populated" input when run at the group level. To validate the 
        returned instances, the test will perform a search 
        on the InsurancePlan resource type using the same coverage-area search 
        parameter and value and check that the instances returned by the tested search are all referenced
        by the owned-by element of instances returned by the additional search.
      )
      
      id :davinci_plan_net_v110_organization_reverse_chain_insurance_plan_owned_by_coverage_area_search_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@22'

      input :insurance_plan_owned_by_coverage_area_input,
        title: '\'coverage-area\' value from an InsurancePlan instance with \'owned-by\' populated',
        description: 'Single value from the \'coverage-area\' element of an InsurancePlan
        on an instance that also references an Organization instance in its \'owned-by\' element to be used for test 
        \'Server capable of reverse chaining through InsurancePlan\'s coverage-area element\' when run at the group level.',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'insurance_plan_owned_by_coverage_area_input',
          reverse_chain_param: 'coverage-area',
          reverse_chain_target: 'owned-by',
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
        scratch[:organization_resources] ||= {}
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
