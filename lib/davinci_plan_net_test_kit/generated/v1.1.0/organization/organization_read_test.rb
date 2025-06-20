require_relative '../../../read_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationReadTest < Inferno::Test
      include DaVinciPlanNetTestKit::ReadTest

      title 'Server returns correct Organization resource from Organization read interaction'
      description 'A server SHALL support the Organization read interaction.'

      id :davinci_plan_net_v110_organization_read_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@25'

      def resource_type
        'Organization'
      end

      def scratch_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
