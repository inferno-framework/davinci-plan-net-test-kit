require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationAffiliationForwardChainServiceLocationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server capable of forward chaining with service.location'
      description %(
        A server SHALL be capable of supporting chaining for location through the search parameter service
        for the Organization_affiliation profile.

        This test will perform a search with service.location and
        will pass if an OrganizationAffiliation resource is found in the response.
      )

      id :davinci_plan_net_v110_forward_chain_service_location_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'OrganizationAffiliation',
          search_param_names: [],
          chain_param: 'location',
          chain_param_base: 'service',
          additional_resource_type: 'HealthcareService'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'healthcare_service', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_affiliation_resources] ||= {}
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