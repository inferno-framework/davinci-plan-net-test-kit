require_relative '../../../validation_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class HealthcareServiceValidationTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::ValidationTest

      id :davinci_pdex_plan_net_v110_healthcare_service_validation_test
      title 'HealthcareService resources returned during previous tests conform to the Plan-Net HealthcareService'
      description %(
This test verifies resources returned from the first search conform to
the [Plan-Net HealthcareService](http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-HealthcareService).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'HealthcareService'
      end

      def scratch_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-HealthcareService',
                                '1.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
