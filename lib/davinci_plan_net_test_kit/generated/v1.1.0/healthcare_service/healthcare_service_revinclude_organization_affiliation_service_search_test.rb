require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class HealthcareServiceRevincludeOrganizationAffiliationServiceSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns OrganizationAffiliation resources from HealthcareService search with _revinclude=OrganizationAffiliation:service'
      description %(
        A server SHALL be capable of supporting searches _revincludes on search parameter OrganizationAffiliation:service.

        This test will perform a search on HealthcareService with _revinclude=OrganizationAffiliation:service and the '_id'
        search parameter using an id previously identified during a suite level run or an id provided
        in the "HealthcareService instance ids referenced in OrganizationAffiliation.service" input if run at the group level.
        The test will pass if at least one OrganizationAffiliation resource found in the response
        and each instance that does includes a reference to the HealthcareService with the searched id.
      )

      id :davinci_plan_net_v110_revinclude_healthcare_service_organization_affiliation_service_search_test
      input :organization_affiliation_service_input,
        title: 'HealthcareService instance ids referenced in OrganizationAffiliation.service',
        description: %(Comma separated list of HealthcareService instance ids that are referenced by an OrganizationAffiliation
        instance in its service element. Used for test "Server returns OrganizationAffiliation resources from HealthcareService search with _revinclude=OrganizationAffiliation:service"
        when run at the group level.),
        optional: true
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'HealthcareService',
          search_param_names: [],
          input_name: 'organization_affiliation_service_input',
          revinclude_param: 'OrganizationAffiliation:service',
          rev_param_sp: 'service',
          additional_resource_type: 'OrganizationAffiliation'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'org_affil', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:organization_affiliation_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
