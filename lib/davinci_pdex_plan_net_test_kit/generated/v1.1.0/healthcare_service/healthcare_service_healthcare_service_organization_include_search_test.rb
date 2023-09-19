require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class HealthcareServiceHealthcareServiceOrganizationIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Organization resources from HealthcareService search by _include=HealthcareService:organization'
      description %(
        A server SHALL be capable of supporting _includes for HealthcareService:organization.

        This test will perform a search by _include=HealthcareService:organization and
        will pass if a Organization resource is found in the response.
      )

      id :davinci_plan_net_v110_healthcare_service_healthcare_service_organization_include_search_test
      input :healthcare_service_organization_input,
        title: 'IDs of HealthcareService that have Organization reference(s)',
        description: 'Comma separated list of HealthcareService IDs that reference by a Organization'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'HealthcareService',
          search_param_names: [],
          input_name: 'healthcare_service_organization_input',
          include_param: 'HealthcareService:organization',
          additional_resource_type: 'Organization'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.include_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'Organization', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      def scratch_include_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end