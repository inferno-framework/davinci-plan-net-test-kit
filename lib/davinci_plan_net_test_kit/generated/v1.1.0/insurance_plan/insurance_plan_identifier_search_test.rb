require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class InsurancePlanIdentifierSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns valid results for InsurancePlan search by identifier'
      description %(
A server SHALL support searching by
identifier on the InsurancePlan resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[Plan Net Server CapabilityStatement](http://hl7.org/fhir/us/davinci-pdex-plan-net/STU1.1/CapabilityStatement/plan-net)

      )

      id :davinci_plan_net_v110_insurance_plan_identifier_search_test
      optional
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'InsurancePlan',
        search_param_names: ['identifier'],
        token_search_params: ['identifier']
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
