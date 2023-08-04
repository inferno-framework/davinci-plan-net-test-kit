require_relative '../../../read_test'

module DaVinciPDEXPlanNetTestKit
  module USCoreV110
    class EndpointReadTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::ReadTest

      title 'Server returns correct Endpoint resource from Endpoint read interaction'
      description 'A server SHALL support the Endpoint read interaction.'

      id :us_core_v110_endpoint_read_test

      def resource_type
        'Endpoint'
      end

      def scratch_resources
        scratch[:endpoint_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'Endpoint'))
      end
    end
  end
end
