require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PlannetNetworkRevincludeInsuranceplanAdministeredBySearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns InsurancePlan resources from Organization search by _revinclude=InsurancePlan:administered-by'
      description %(
        A server SHALL be capable of supporting _revIncludes for InsurancePlan:administered-by.

        This test will perform a search by _revinclude=InsurancePlan:administered-by and
        will pass if a InsurancePlan resource is found in the response.
      )

      id :us_core_v110_plannet_network_revinclude_InsurancePlan_administered_by_search_test
  
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          revinclude_param: 'InsurancePlan:administered-by'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'InsurancePlan', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:plannet_network_resources] ||= {}
      end

      def scratch_revinclude_resources
        scratch[:revinclude_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
