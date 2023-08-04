require_relative '../../../read_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationReadTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::ReadTest

      title 'Server returns correct Location resource from Location read interaction'
      description 'A server SHALL support the Location read interaction.'

      id :davinci_pdex_plan_net_v110_location_read_test

      def resource_type
        'Location'
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'Location'))
      end
    end
  end
end
