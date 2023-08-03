require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module USCoreV110
    class InsurancePlanPlanTypeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns valid results for InsurancePlan search by plan-type'
      description %(
A server SHALL support searching by
plan-type on the InsurancePlan resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core//CapabilityStatement-us-core-server.html)

      )

      id :us_core_v110_insurance_plan_plan_type_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'InsurancePlan',
        search_param_names: ['plan-type'],
        token_search_params: ['plan-type']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:insurance_plan_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
