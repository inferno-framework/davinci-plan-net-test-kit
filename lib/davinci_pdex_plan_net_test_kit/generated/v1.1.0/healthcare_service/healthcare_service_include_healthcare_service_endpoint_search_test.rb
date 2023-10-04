require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class HealthcareServiceIncludeHealthcareServiceEndpointSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Endpoint resources from HealthcareService search with _include=HealthcareService:endpoint'
      description %(
        A server SHALL be capable of supporting _includes for HealthcareService:endpoint.

        This test will perform a search with _include=HealthcareService:endpoint and
        will pass if a Endpoint resource is found in the response.
      )

      id :davinci_plan_net_v110_include_healthcare_service_healthcare_service_endpoint_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'HealthcareService',
          search_param_names: [],
          include_param: 'HealthcareService:endpoint',
          inc_param_sp: 'endpoint',
          additional_resource_type: 'Endpoint'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'endpoint', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      def scratch_include_resources
        scratch[:endpoint_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end