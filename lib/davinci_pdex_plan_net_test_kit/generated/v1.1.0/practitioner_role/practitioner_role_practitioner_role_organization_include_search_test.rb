require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PractitionerRolePractitionerRoleOrganizationIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Organization resources from PractitionerRole search by _include=PractitionerRole:organization'
      description %(
        A server SHALL be capable of supporting _includes for PractitionerRole:organization.

        This test will perform a search by _include=PractitionerRole:organization and
        will pass if a Organization resource is found in the response.
      )

      id :davinci_plan_net_v110_practitioner_role_practitioner_role_organization_include_search_test
      input :practitioner_role_organization_input,
        title: 'IDs of PractitionerRole that have Organization reference(s)',
        description: 'Comma separated list of PractitionerRole IDs that reference by a Organization',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'PractitionerRole',
          search_param_names: [],
          input_name: 'practitioner_role_organization_input',
          include_param: 'PractitionerRole:organization',
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
        scratch[:practitioner_role_resources] ||= {}
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