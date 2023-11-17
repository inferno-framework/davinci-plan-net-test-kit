require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationRevincludeHealthcareServiceOrganizationSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns HealthcareService resources from Organization search with _revinclude=HealthcareService:organization'
      description %(
        A server SHALL be capable of supporting searches _revIncludes on search parameter HealthcareService:organization.

        This test will perform a search on Organization with _revinclude=HealthcareService:organization and the '_id'
        search parameter using an id previoiusly identified when the whole test suite is run or an id provided
        in the "Organization instance ids referenced in HealthcareService.organization" input if run at the group level.
        The test will pass if at least one HealthcareService resource found in the response
        and each instance that does includes a reference to the Organization with the searched id.
      )

      id :davinci_plan_net_v110_revinclude_organization_healthcare_service_organization_search_test
      input :healthcare_service_organization_input,
        title: 'Organization instance ids referenced in HealthcareService.organization',
        description: %(Comma separated list of Organization instance ids that are referenced by a HealthcareService
        instance in its organization element. Used for test "Server returns HealthcareService resources from Organization search with _revinclude=HealthcareService:organization"
        when run at the group level.),
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
