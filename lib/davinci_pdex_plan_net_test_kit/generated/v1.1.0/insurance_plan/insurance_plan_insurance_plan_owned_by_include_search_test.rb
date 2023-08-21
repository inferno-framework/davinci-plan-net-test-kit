require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class InsurancePlanInsurancePlanOwnedByIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Organization resources from InsurancePlan search by _include=InsurancePlan:owned-by'
      description %(
        A server SHALL be capable of supporting _includes for InsurancePlan:owned-by.

        This test will perform a search by _include=InsurancePlan:owned-by and
        will pass if a Organization resource is found in the response.
      )

      id :davinci_plan_net_v110_insurance_plan_insurance_plan_owned_by_include_search_test
      input :insurance_plan_owned_by_input,
        title: 'IDs of InsurancePlan that have Organization reference(s)',
        description: 'Comma separated list of InsurancePlan IDs that reference by a Organization'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'InsurancePlan',
          search_param_names: [],
          input_name: 'insurance_plan_owned_by_input',
          include_param: 'InsurancePlan:owned-by',
          additional_resource_type: 'Organization'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.include_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'Organization', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:insurance_plan_resources] ||= {}
      end

      def scratch_include_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end