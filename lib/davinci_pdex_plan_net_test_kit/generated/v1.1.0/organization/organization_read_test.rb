require_relative '../../../read_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationReadTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::ReadTest

      title 'Server returns correct Organization resource from Organization read interaction'
      description 'A server SHALL support the Organization read interaction.'

      id :davinci_pdex_plan_net_v110_organization_read_test

      def resource_type
        'Organization'
      end

      def scratch_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'Organization'))
      end
    end
  end
end