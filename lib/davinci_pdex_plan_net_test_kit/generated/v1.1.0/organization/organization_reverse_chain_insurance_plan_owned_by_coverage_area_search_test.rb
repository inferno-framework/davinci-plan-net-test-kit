require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationReverseChainInsurancePlanOwnedByCoverageAreaSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Example Test of _has:InsurancePlan:owned-by:coverage-area'
      description %(
        Placeholder test for reverse chaining
      )
      
      id :davinci_plan_net_v110_organization_reverse_chain_insurance_plan_owned_by_coverage_area_search_test
      id :davinci_plan_net_v110_organization_reverse_chain_insurance_plan_owned_by_coverage_area_search_test
      input :insurance_plan_owned_by_coverage_area_input,
        title: 'coverage-area field value for InsurancePlan',
        description: 'Value from the coverage-area field of an InsurancePlan
        that also references a Organization instance in its owned-by field',
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

      def scratch_chain_resources
        scratch[:insurance_plan_resources] ||= {}
      end

      run do
        run_reverse_chain_search_test
      end
    end
  end
end
