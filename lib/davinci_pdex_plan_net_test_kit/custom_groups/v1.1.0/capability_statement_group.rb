require 'tls_test_kit'
require_relative '../capability_statement/conformance_support_test'
require_relative '../capability_statement/fhir_version_test'
require_relative '../capability_statement/json_support_test'
require_relative '../capability_statement/profile_support_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class CapabilityStatementGroup < Inferno::TestGroup
      id :davinci_pdex_plan_net_v110_capability_statement
      title 'Capability Statement'
      short_description 'Retrieve information about supported server functionality using the FHIR capabilties interaction.'
      description %(
        # Background
        The #{title} Sequence tests a FHIR server's ability to formally describe
        features supported by the API by using the [Capability
        Statement](https://www.hl7.org/fhir/capabilitystatement.html) resource.
        The features described in the Capability Statement must be consistent with
        the required capabilities of a Plan Net server.  This test also expects
        that APIs state support for all resources types applicable to PDEX v1.1.0.

        # Test Methodology

        This test sequence accesses the server endpoint at `/metadata` using a
        `GET` request. It parses the Capability Statement and verifies that:

        * The endpoint is secured by an appropriate cryptographic protocol
        * The resource matches the expected FHIR version defined by the tests
        * The resource is a valid FHIR resource
        * The server claims support for JSON encoding of resources
        * The server claims support for all resources.

        It collects the following information that is saved in the testing session
        for use by later tests:

        * List of resources supported
        * List of queries parameters supported
      )
      run_as_group

      PROFILES = {
        'Endpoint' => ['http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Endpoint'].freeze,
        'HealthcareService' => ['http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-HealthcareService'].freeze,
        'Location' => ['http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Location'].freeze,
        'Organization' => [
          'http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Network',
          'http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Organization'
        ].freeze,
        'OrganizationAffiliation' => ['http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-OrganizationAffiliation'].freeze,
        'Practitioner' => ['http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Practitioner'].freeze,
        'PractitionerRole' => ['http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-PractitionerRole'].freeze
      }.freeze

      test from: :tls_version_test,
          id: :standalone_auth_tls,
          title: 'FHIR server secured by transport layer security',
          description: %(
            Systems **SHALL** use TLS version 1.2 or higher for all transmissions
            not taking place over a secure network connection.
          ),
          config: {
            options: {  minimum_allowed_version: OpenSSL::SSL::TLS1_2_VERSION }
          }
      test from: :davinci_pdex_plan_net_conformance_support
      test from: :davinci_pdex_plan_net_fhir_version
      test from: :davinci_pdex_plan_net_json_support

      test from: :davinci_pdex_plan_net_profile_support do
        config(
          options: { davinci_pdex_plan_net_profiles: PROFILES.values.flatten }
        )
      end
    end
  end
end
