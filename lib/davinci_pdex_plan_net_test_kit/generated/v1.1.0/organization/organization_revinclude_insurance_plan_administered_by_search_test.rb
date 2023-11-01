require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationRevincludeInsurancePlanAdministeredBySearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns InsurancePlan resources from Organization search with _revinclude=InsurancePlan:administered-by'
      description %(
        A server SHALL be capable of supporting _revIncludes for InsurancePlan:administered-by.

        This test will perform a search with _revinclude=InsurancePlan:administered-by and
        will pass if a InsurancePlan resource is found in the response.
      )

      id :davinci_plan_net_v110_revinclude_organization_insurance_plan_administered_by_search_test
      input :insurance_plan_administered_by_input,
        title: 'InsurancePlan referenced Organization IDs',
        description: 'Comma separated list of Organization  IDs that are referenced by a InsurancePlan',
        optional: true
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'insurance_plan_administered_by_input',
          revinclude_param: 'InsurancePlan:administered-by',
          rev_param_sp: 'administered-by',
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
        run_revinclude_search_test
      end
    end
  end
end
