require 'inferno/dsl/oauth_credentials'
require_relative '../../version'
require_relative '../../custom_groups/v1.1.0/capability_statement_group'
require_relative 'endpoint_group'
require_relative 'healthcare_service_group'
require_relative 'insurance_plan_group'
require_relative 'location_group'
require_relative 'organization_group'
require_relative 'organization_group'
require_relative 'organization_affiliation_group'
require_relative 'practitioner_group'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class DaVinciPDEXPlanNetTestSuite < Inferno::TestSuite
      title 'DaVinci PDEX Plan Net v1.1.0'
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

      id :davincin_pdex_plan_net_v110

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

      group from: :davinci_pdex_plan_net_v110_capability_statement
  
      group from: :davinci_pdex_plan_net_v110_endpoint
      group from: :davinci_pdex_plan_net_v110_healthcare_service
      group from: :davinci_pdex_plan_net_v110_insurance_plan
      group from: :davinci_pdex_plan_net_v110_location
      group from: :davinci_pdex_plan_net_v110_organization
      group from: :davinci_pdex_plan_net_v110_organization
      group from: :davinci_pdex_plan_net_v110_organization_affiliation
      group from: :davinci_pdex_plan_net_v110_practitioner
    end
  end
end