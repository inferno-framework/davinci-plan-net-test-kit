require_relative '../../../read_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrgAffilReadTest < Inferno::Test
      include DaVinciPlanNetTestKit::ReadTest

      title 'Server returns correct OrganizationAffiliation resource from OrganizationAffiliation read interaction'
      description 'A server SHALL support the OrganizationAffiliation read interaction.'

      id :davinci_plan_net_v110_org_affil_read_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@25'

      def resource_type
        'OrganizationAffiliation'
      end

      def scratch_resources
        scratch[:org_affil_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
