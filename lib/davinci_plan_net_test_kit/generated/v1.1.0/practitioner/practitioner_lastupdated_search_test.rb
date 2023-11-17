require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class PractitionerLastupdatedSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns valid results for Practitioner search by _lastUpdated'
      description %(
A server SHALL support searching by
_lastUpdated on the Practitioner resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[Plan Net Server CapabilityStatement](http://hl7.org/fhir/us/davinci-pdex-plan-net/CapabilityStatement/plan-net)

      )

      id :davinci_plan_net_v110_practitioner__lastUpdated_search_test
      optional
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Practitioner',
        search_param_names: ['_lastUpdated']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
