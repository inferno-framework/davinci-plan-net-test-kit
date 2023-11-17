require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class LocationEndpointSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns valid results for Location search by endpoint'
      description %(
A server SHALL support searching by
endpoint on the Location resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[Plan Net Server CapabilityStatement](http://hl7.org/fhir/us/davinci-pdex-plan-net/CapabilityStatement/plan-net)

      )

      id :davinci_plan_net_v110_location_endpoint_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Location',
        search_param_names: ['endpoint']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
