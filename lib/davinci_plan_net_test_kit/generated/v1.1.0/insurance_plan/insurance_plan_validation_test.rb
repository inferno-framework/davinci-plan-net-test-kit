require_relative '../../../validation_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class InsurancePlanValidationTest < Inferno::Test
      include DaVinciPlanNetTestKit::ValidationTest

      id :davinci_plan_net_v110_insurance_plan_validation_test
      title 'InsurancePlan resources returned during previous tests conform to the Plan-Net InsurancePlan'
      description %(
This test verifies resources returned from the first search conform to
the [Plan-Net InsurancePlan](http://hl7.org/fhir/us/davinci-pdex-plan-net/STU1.1/StructureDefinition/plannet-InsurancePlan).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'InsurancePlan'
      end

      def scratch_resources
        scratch[:insurance_plan_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-InsurancePlan',
                                '1.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
