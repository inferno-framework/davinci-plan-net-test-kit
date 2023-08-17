require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PlannetOrganizationInsuranceplanOwnedByRevincludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns InsurancePlan resources from Organization search by _revinclude=InsurancePlan:owned-by'
      description %(
        A server SHALL be capable of supporting _revIncludes for InsurancePlan:owned-by.

        This test will perform a search by _revinclude=InsurancePlan:owned-by and
        will pass if a InsurancePlan resource is found in the response.
      )

      id :davinci_plan_net_v110_v110_plannet_organization_insuranceplan_owned_by_revinclude_search_test
      input :insuranceplan_owned_by_input,
        title: 'InsurancePlan referenced Organization IDs',
        description: 'Comma separated list of Organization  IDs that are referenced by a InsurancePlan'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'insuranceplan_owned_by_input',
          revinclude_param: 'InsurancePlan:owned-by'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'InsurancePlan', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:plannet_organization_resources] ||= {}
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
