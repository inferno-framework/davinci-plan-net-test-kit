require_relative '../../../read_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class EndpointReadTest < Inferno::Test
      include DaVinciPlanNetTestKit::ReadTest

      title 'Server returns correct Endpoint resource from Endpoint read interaction'
      description 'A server SHALL support the Endpoint read interaction.'

      id :davinci_plan_net_v110_endpoint_read_test

      def resource_type
        'Endpoint'
      end

      def scratch_resources
        scratch[:endpoint_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
