require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class HealthcareServiceNameSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns valid results for HealthcareService search by name'
      description %(
A server SHALL support searching by
name on the HealthcareService resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[Plan Net Server CapabilityStatement](http://hl7.org/fhir/us/davinci-pdex-plan-net/STU1.1/CapabilityStatement/plan-net)

      )

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@19'

      id :davinci_plan_net_v110_healthcare_service_name_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'HealthcareService',
        search_param_names: ['name']
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
