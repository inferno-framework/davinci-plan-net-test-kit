require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class InsurancePlanIncludeInsurancePlanAdministeredBySearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns Organization resources from InsurancePlan search with _include=InsurancePlan:administered-by'
      description %(
        A server SHALL be capable of supporting _includes on search parameter InsurancePlan:administered-by.

        This test will perform a search on InsurancePlan with _include=InsurancePlan:administered-by 
        and the '_id' search parameter using an id with a reference to an Organization
        identified during instance gathering. The test will pass if at least one Organization 
        resource is found in the response and each instance that does is referenced by a returned InsurancePlan instance.
      )

      id :davinci_plan_net_v110_include_insurance_plan_insurance_plan_administered_by_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'InsurancePlan',
          search_param_names: [],
          include_param: 'InsurancePlan:administered-by',
          inc_param_sp: 'administered-by',
          additional_resource_type: 'Organization'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'organization', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:insurance_plan_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end