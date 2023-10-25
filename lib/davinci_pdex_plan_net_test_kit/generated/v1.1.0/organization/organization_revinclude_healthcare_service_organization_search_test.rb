require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationRevincludeHealthcareServiceOrganizationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns HealthcareService resources from Organization search with _revinclude=HealthcareService:organization'
      description %(
        A server SHALL be capable of supporting _revIncludes for HealthcareService:organization.

        This test will perform a search with _revinclude=HealthcareService:organization and
        will pass if a HealthcareService resource is found in the response.
      )

      id :davinci_plan_net_v110_revinclude_organization_healthcare_service_organization_search_test
      input :healthcare_service_organization_input,
        title: 'HealthcareService referenced Organization IDs',
        description: 'Comma separated list of Organization  IDs that are referenced by a HealthcareService',
        optional: true
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'healthcare_service_organization_input',
          revinclude_param: 'HealthcareService:organization',
          rev_param_sp: 'organization',
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
        scratch[:organization_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
