require_relative '../../../validation_test'

module DaVinciPDEXPlanNetTestKit
  module USCoreV110
    class OrganizationAffiliationValidationTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::ValidationTest

      id :us_core_v110_organization_affiliation_validation_test
      title 'OrganizationAffiliation resources returned during previous tests conform to the Plan-Net OrganizationAffiliation'
      description %(
This test verifies resources returned from the first search conform to
the [Plan-Net OrganizationAffiliation](http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-OrganizationAffiliation).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'OrganizationAffiliation'
      end

      def scratch_resources
        scratch[:organization_affiliation_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-OrganizationAffiliation',
                                '1.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
