require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class NetworkOrganizationAffiliationParticipatingOrganizationRevincludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns OrganizationAffiliation resources from Organization search by _revinclude=OrganizationAffiliation:participating-organization'
      description %(
        A server SHALL be capable of supporting _revIncludes for OrganizationAffiliation:participating-organization.

        This test will perform a search by _revinclude=OrganizationAffiliation:participating-organization and
        will pass if a OrganizationAffiliation resource is found in the response.
      )

      id :davinci_plan_net_v110_network_organization_affiliation_participating_organization_revinclude_search_test
      input :organization_affiliation_participating_organization_input,
        title: 'OrganizationAffiliation referenced Organization IDs',
        description: 'Comma separated list of Organization  IDs that are referenced by a OrganizationAffiliation',
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

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'OrganizationAffiliation', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:network_resources] ||= {}
      end

      def scratch_revinclude_resources
        scratch[:OrganizationAffiliation_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
