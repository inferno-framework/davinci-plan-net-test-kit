require_relative '../../../validation_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class NetworkValidationTest < Inferno::Test
      include DaVinciPlanNetTestKit::ValidationTest

      id :davinci_plan_net_v110_network_validation_test
      title 'Organization resources returned during previous tests conform to the Plan-Net Network'
      description %(
This test verifies resources returned from the first search conform to
the [Plan-Net Network](http://hl7.org/fhir/us/davinci-pdex-plan-net/STU1.1/StructureDefinition/plannet-Network).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'Organization'
      end

      def scratch_resources
        scratch[:network_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Network',
                                '1.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
