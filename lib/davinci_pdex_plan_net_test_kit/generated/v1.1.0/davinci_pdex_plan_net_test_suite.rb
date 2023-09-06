require 'inferno/dsl/oauth_credentials'
require_relative '../../version'
require_relative '../../custom_groups/v1.1.0/capability_statement_group'
require_relative 'endpoint_group'
require_relative 'insurance_plan_group'
require_relative 'organization_affiliation_group'
require_relative 'practitioner_role_group'
require_relative 'practitioner_group'
require_relative 'healthcare_service_group'
require_relative 'location_group'
require_relative 'plannet_network_group'
require_relative 'plannet_organization_group'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class DaVinciPDEXPlanNetTestSuite < Inferno::TestSuite
      title 'DaVinci PDEX Plan Net v1.1.0'
      description %(
        The Plan Net Test Kit tests systems for their conformance to the [Plan Net
        Implementation Guide](http://hl7.org/fhir/us/davinci-pdex-plan-net/STU1.1/).

        HL7® FHIR® resources are validated with the Java validator using
        `tx.fhir.org` as the terminology server.
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

      id :davinci_pdex_plan_net_v110

      input :url,
        title: 'FHIR Endpoint',
        description: 'URL of the FHIR endpoint'
      input :smart_credentials,
        title: 'OAuth Credentials',
        type: :oauth_credentials,
        optional: true
      input :no_param_search,
        title: 'Use parameterless searches to identify instances?',
        type: 'radio',
        options: {
            list_options: [
              {
                label: 'Yes',
                value: 'true'
              },
              {
                label: 'No',
                value: 'false'
              }
            ]
          },
        default: 'true',
        description: 'If No, then the lists of ids by profile are required. If yes, the lists of ids by profile are optional.'
      input :max_instances,
        title: 'Maximum number of instances to gather using parameterless searches',
        default: '200',
        description: 'Only used when parameterless searches are used. A higher number will evaluate more instances in the tests, if they are available. The test Will stop looking when the page limit has been reached.'
      input :max_pages,
        title: 'Maximum pages of results to consider when using parameterless searches',
        default: '20',
        description: 'Only used when parameterless searches are used. A higher number will evaluate more instances in the tests, if they are available. The test will not consider further pages once the maximum number of instances has been reached.'
      
      fhir_client do
        url :url
        oauth_credentials :smart_credentials
      end

      group from: :davinci_pdex_plan_net_v110_capability_statement
  
      group from: :davinci_pdex_plan_net_v110_endpoint
      group from: :davinci_pdex_plan_net_v110_insurance_plan
      group from: :davinci_pdex_plan_net_v110_organization_affiliation
      group from: :davinci_pdex_plan_net_v110_practitioner_role
      group from: :davinci_pdex_plan_net_v110_practitioner
      group from: :davinci_pdex_plan_net_v110_healthcare_service
      group from: :davinci_pdex_plan_net_v110_location
      group from: :davinci_pdex_plan_net_v110_plannet_network
      group from: :davinci_pdex_plan_net_v110_plannet_organization
    end
  end
end
