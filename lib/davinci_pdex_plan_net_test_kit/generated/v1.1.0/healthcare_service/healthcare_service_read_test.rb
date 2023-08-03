require_relative '../../../read_test'

module DaVinciPDEXPlanNetTestKit
  module USCoreV110
    class HealthcareServiceReadTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::ReadTest

      title 'Server returns correct HealthcareService resource from HealthcareService read interaction'
      description 'A server SHALL support the HealthcareService read interaction.'

      id :us_core_v110_healthcare_service_read_test

      def resource_type
        'HealthcareService'
      end

      def scratch_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'HealthcareService'))
      end
    end
  end
end
