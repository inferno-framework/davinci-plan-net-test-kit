require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class NetworkNoParamsSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns valid results for Organization search without filters'
      description %(
A server SHALL support searching on the 
Organization resource withough parameters. This test
will pass if resources are returned. If none are returned, 
the test is skipped.

Because this is the first search of the sequence, resources in the
response will be used for subsequent tests.

[Plan Net Server CapabilityStatement](http://hl7.org/fhir/us/davinci-pdex-plan-net/CapabilityStatement/plan-net)

      )

      id :davinci_pdex_plan_net_v110_network_no_params_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          first_search: true,
        resource_type: 'Organization',
        saves_delayed_references: true,
        test_post_search: false
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:network_resources] ||= {}
      end

      run do
        run_search_no_params_test
      end
    end
  end
end
