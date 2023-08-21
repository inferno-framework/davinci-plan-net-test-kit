require_relative '../../../read_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class InsurancePlanReadTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::ReadTest

      title 'Server returns correct InsurancePlan resource from InsurancePlan read interaction'
      description 'A server SHALL support the InsurancePlan read interaction.'

      id :davinci_pdex_plan_net_v110_insurance_plan_read_test

      def resource_type
        'InsurancePlan'
      end

      def scratch_resources
        scratch[:insurance_plan_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
