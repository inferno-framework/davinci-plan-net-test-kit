require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationRevincludeInsurancePlanOwnedBySearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns InsurancePlan resources from Organization search with _revinclude=InsurancePlan:owned-by'
      description %(
        A server SHALL be capable of supporting searches _revincludes on search parameter InsurancePlan:owned-by.

        This test will perform a search on Organization with _revinclude=InsurancePlan:owned-by and the '_id'
        search parameter using an id previously identified during a suite level run or an id provided
        in the "Organization instance ids referenced in InsurancePlan.owned-by" input if run at the group level.
        The test will pass if at least one InsurancePlan resource found in the response
        and each instance that does includes a reference to the Organization with the searched id.
      )

      id :davinci_plan_net_v110_revinclude_organization_insurance_plan_owned_by_search_test
      input :insurance_plan_owned_by_input,
        title: 'Organization instance ids referenced in InsurancePlan.owned-by',
        description: %(Comma separated list of Organization instance ids that are referenced by an InsurancePlan
        instance in its owned-by element. Used for test "Server returns InsurancePlan resources from Organization search with _revinclude=InsurancePlan:owned-by"
        when run at the group level.),
        optional: true
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'insurance_plan_owned_by_input',
          revinclude_param: 'InsurancePlan:owned-by',
          rev_param_sp: 'owned-by',
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
