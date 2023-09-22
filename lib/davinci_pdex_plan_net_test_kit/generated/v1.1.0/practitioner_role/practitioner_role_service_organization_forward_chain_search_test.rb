require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PractitionerRoleServiceOrganizationForwardChainSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns PractitionerRole that populate the organization field of a HealthcareService instance'
      description %(
        A server SHALL be capable of supporting chaining for organization.

        This test will perform a search with organization and
        will pass if a organization resource is found in the response.
      )

      id :davinci_plan_net_v110_service_organization_forward_chain_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'PractitionerRole',
          search_param_names: [],
          chain_param: 'organization',
          chain_param_base: 'service',
          additional_resource_type: 'HealthcareService'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.chain_metadata
        @include_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'HealthcareService', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      def scratch_chain_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      run do
        run_forward_chain_search_test
      end
    end
  end
end