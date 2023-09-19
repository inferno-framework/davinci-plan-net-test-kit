require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationPractitionerRoleOrganizationRevincludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns PractitionerRole resources from Organization search by _revinclude=PractitionerRole:organization'
      description %(
        A server SHALL be capable of supporting _revIncludes for PractitionerRole:organization.

        This test will perform a search by _revinclude=PractitionerRole:organization and
        will pass if a PractitionerRole resource is found in the response.
      )

      id :davinci_plan_net_v110_organization_practitioner_role_organization_revinclude_search_test
      input :practitioner_role_organization_input,
        title: 'PractitionerRole referenced Organization IDs',
        description: 'Comma separated list of Organization  IDs that are referenced by a PractitionerRole'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'practitioner_role_organization_input',
          revinclude_param: 'PractitionerRole:organization',
          additional_resource_type: 'PractitionerRole'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'PractitionerRole', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_resources] ||= {}
      end

      def scratch_revinclude_resources
        scratch[:practitionerrole_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
