require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationRevincludeOrganizationAffiliationPrimaryOrganizationSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns OrganizationAffiliation resources from Organization search with _revinclude=OrganizationAffiliation:primary-organization'
      description %(
        A server SHALL be capable of supporting searches _revincludes on search parameter OrganizationAffiliation:primary-organization.

        This test will perform a search on Organization with _revinclude=OrganizationAffiliation:primary-organization and the '_id'
        search parameter using an id previously identified during a suite level run or an id provided
        in the "Organization instance ids referenced in OrganizationAffiliation.primary-organization" input if run at the group level.
        The test will pass if at least one OrganizationAffiliation resource found in the response
        and each instance that does includes a reference to the Organization with the searched id.
      )

      id :davinci_plan_net_v110_revinclude_organization_organization_affiliation_primary_organization_search_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@28'

      input :organization_affiliation_primary_organization_input,
        title: 'Organization instance ids referenced in OrganizationAffiliation.primary-organization',
        description: %(Comma separated list of Organization instance ids that are referenced by an OrganizationAffiliation
        instance in its primary-organization element. Used for test "Server returns OrganizationAffiliation resources from Organization search with _revinclude=OrganizationAffiliation:primary-organization"
        when run at the group level.),
        optional: true
        
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'organization_affiliation_primary_organization_input',
          revinclude_param: 'OrganizationAffiliation:primary-organization',
          rev_param_sp: 'primary-organization',
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
        scratch[:organization_resources] ||= {}
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
