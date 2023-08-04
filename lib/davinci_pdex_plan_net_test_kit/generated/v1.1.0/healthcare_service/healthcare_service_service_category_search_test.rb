require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class HealthcareServiceServiceCategorySearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns valid results for HealthcareService search by service-category'
      description %(
A server SHALL support searching by
service-category on the HealthcareService resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core//CapabilityStatement-us-core-server.html)

      )

      id :davinci_pdex_plan_net_v110_healthcare_service_service_category_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'HealthcareService',
        search_param_names: ['service-category'],
        token_search_params: ['service-category']
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