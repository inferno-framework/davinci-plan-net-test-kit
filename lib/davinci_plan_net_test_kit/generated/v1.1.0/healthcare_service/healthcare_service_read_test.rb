require_relative '../../../read_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class HealthcareServiceReadTest < Inferno::Test
      include DaVinciPlanNetTestKit::ReadTest

      title 'Server returns correct HealthcareService resource from HealthcareService read interaction'
      description 'A server SHALL support the HealthcareService read interaction.'

      id :davinci_plan_net_v110_healthcare_service_read_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@25'

      def resource_type
        'HealthcareService'
      end

      def scratch_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
