require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationRevincludeOrganizationAffiliationParticipatingOrganizationSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns OrganizationAffiliation resources from Organization search with _revinclude=OrganizationAffiliation:participating-organization'
      description %(
        A server SHALL be capable of supporting searches _revIncludes on search parameter OrganizationAffiliation:participating-organization.

        This test will perform a search on Organization with _revinclude=OrganizationAffiliation:participating-organization and the '_id'
        search parameter using an id previoiusly identified when the whole test suite is run or an id provided
        in the "Organization instance ids referenced in OrganizationAffiliation.participating-organization" input if run at the group level.
        The test will pass if at least one OrganizationAffiliation resource found in the response
        and each instance that does includes a reference to the Organization with the searched id.
      )

      id :davinci_plan_net_v110_revinclude_organization_organization_affiliation_participating_organization_search_test
      input :organization_affiliation_participating_organization_input,
        title: 'Organization instance ids referenced in OrganizationAffiliation.participating-organization',
        description: %(Comma separated list of Organization instance ids that are referenced by an OrganizationAffiliation
        instance in its participating-organization element. Used for test "Server returns OrganizationAffiliation resources from Organization search with _revinclude=OrganizationAffiliation:participating-organization"
        when run at the group level.),
        optional: true
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'organization_affiliation_participating_organization_input',
          revinclude_param: 'OrganizationAffiliation:participating-organization',
          rev_param_sp: 'participating-organization',
          additional_resource_type: 'OrganizationAffiliation'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'organization_affiliation', 'metadata.yml'), aliases: true))
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
