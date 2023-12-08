require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationAffiliationRoleSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns valid results for OrganizationAffiliation search by role'
      description %(
A server SHALL support searching by
role on the OrganizationAffiliation resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[Plan Net Server CapabilityStatement](http://hl7.org/fhir/us/davinci-pdex-plan-net/STU1.1/CapabilityStatement/plan-net)

      )

      id :davinci_plan_net_v110_organization_affiliation_role_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'OrganizationAffiliation',
        search_param_names: ['role'],
        token_search_params: ['role']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_affiliation_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
