require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class HealthcareServiceLocationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns valid results for HealthcareService search by location'
      description %(
A server SHALL support searching by
location on the HealthcareService resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

Because this is the first search of the sequence, resources in the
response will be used for subsequent tests.

Additionally, this test will check that GET and POST search methods
return the same number of results. Search by POST is required by the
FHIR R4 specification, and these tests interpret search by GET as a
requirement of Plan Net v1.1.0.

[Plan Net Server CapabilityStatement](http://hl7.org/fhir/us/davinci-pdex-plan-net/CapabilityStatement/plan-net)

      )

      id :davinci_pdex_plan_net_v110_healthcare_service_location_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          first_search: true,
        resource_type: 'HealthcareService',
        search_param_names: ['location'],
        saves_delayed_references: true,
        test_post_search: true
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
