require 'inferno/dsl/oauth_credentials'
require_relative '../../version'
require_relative '../../custom_groups/v1.1.0/capability_statement_group'
require_relative '../../custom_groups/v4.0.0/clinical_notes_guidance_group'
require_relative '../../custom_groups/data_absent_reason_group'
require_relative '../../provenance_validator'
require_relative 'endpoint_group'
require_relative 'healthcare_service_group'
require_relative 'insurance_plan_group'
require_relative 'organization_group'
require_relative 'organization_group'
require_relative 'organization_affiliation_group'
require_relative 'practitioner_group'

module DaVinciPDEXPlanNetTestKit
  module USCoreV110
    class USCoreTestSuite < Inferno::TestSuite
      title 'US Core v1.1.0'
      description %(
        The US Core Test Kit tests systems for their conformance to the [US Core
        Implementation Guide]().

        HL7® FHIR® resources are validated with the Java validator using
        `tx.fhir.org` as the terminology server. Users should note that the
        although the ONC Certification (g)(10) Standardized API Test Suite
        includes tests from this suite, [it uses a different method to perform
        terminology
        validation](https://github.com/onc-healthit/onc-certification-g10-test-kit/wiki/FAQ#q-why-do-some-resources-fail-in-us-core-test-kit-with-terminology-validation-errors).
        As a result, resource validation results may not be consistent between
        the US Core Test Suite and the ONC Certification (g)(10) Standardized
        API Test Suite.
      )
      version VERSION

      VALIDATION_MESSAGE_FILTERS = [
        %r{Sub-extension url 'introspect' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        %r{Sub-extension url 'revoke' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        /Observation\.effective\.ofType\(Period\): .*vs-1:/, # Invalid invariant in FHIR v4.0.1
        /Observation\.effective\.ofType\(Period\): .*us-core-1:/, # Invalid invariant in US Core v3.1.1
        /Provenance.agent\[\d*\]: Rule provenance-1/ #Invalid invariant in US Core v5.0.1
      ].freeze

      VERSION_SPECIFIC_MESSAGE_FILTERS = [].freeze

      def self.metadata
        @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
            Generator::GroupMetadata.new(raw_metadata)
          end
      end

      validator do
        url ENV.fetch('V110_VALIDATOR_URL', 'http://validator_service:4567')
        message_filters = VALIDATION_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

        exclude_message do |message|

          message_filters.any? { |filter| filter.match? message.message }
        end

        perform_additional_validation do |resource, profile_url|
          ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
        end
      end

      id :us_core_v110

      input :url,
        title: 'FHIR Endpoint',
        description: 'URL of the FHIR endpoint'
      input :smart_credentials,
        title: 'OAuth Credentials',
        type: :oauth_credentials,
        optional: true

      fhir_client do
        url :url
        oauth_credentials :smart_credentials
      end

      group from: :us_core_v110_capability_statement
  
      group from: :us_core_v110_endpoint
      group from: :us_core_v110_healthcare_service
      group from: :us_core_v110_insurance_plan
      group from: :us_core_v110_organization
      group from: :us_core_v110_organization
      group from: :us_core_v110_organization_affiliation
      group from: :us_core_v110_practitioner
      group from: :us_core_v400_clinical_notes_guidance
      group from: :us_core_311_data_absent_reason
    end
  end
end
