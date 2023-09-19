require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class InsurancePlanNoParamsSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Client can identify instances of Plan-Net InsurancePlan on the server'
      description %(
A server SHALL support searching on the 
InsurancePlan resource withough parameters. This test
will pass if resources are returned. If none are returned, 
the test is skipped.

Because this is the first search of the sequence, resources in the
response will be used for subsequent tests.

[Plan Net Server CapabilityStatement](http://hl7.org/fhir/us/davinci-pdex-plan-net/CapabilityStatement/plan-net)

      )

      id :davinci_pdex_plan_net_v110_insurance_plan_no_params_search_test

      input :davinci_pdex_plan_net_v110_insurance_plan_no_params_search_test_ids,
        title: 'Ids of instances of Plan-Net InsurancePlan',
        optional: true,
        description: 'Required if parameterless searches not used.'
      input :no_param_search
      input :max_instances
      input :max_pages

      def self.properties
        @properties ||= SearchTestProperties.new(
          first_search: true,
        resource_type: 'InsurancePlan',
        test_post_search: false
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:insurance_plan_resources] ||= {}
      end

      run do
        run_search_no_params_test(davinci_pdex_plan_net_v110_insurance_plan_no_params_search_test_ids)
      end
    end
  end
end
