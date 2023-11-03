require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PractitionerRoleIncludePractitionerRoleOrganizationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Organization resources from PractitionerRole search with _include=PractitionerRole:organization'
      description %(
        A server SHALL be capable of supporting _includes on search parameter PractitionerRole:organization.

        This test will perform a search on PractitionerRole with _include=PractitionerRole:organization 
        and the '_id' search parameter using an id with a reference to a Organization
        identified during instance gathering. The test will pass if at least one Organization 
        resource is found in the response and each instance that does is referenced by a returned PractitionerRole instance.
      )

      id :davinci_plan_net_v110_include_practitioner_role_practitioner_role_organization_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'PractitionerRole',
          search_param_names: [],
          include_param: 'PractitionerRole:organization',
          inc_param_sp: 'organization',
          additional_resource_type: 'Organization'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'organization', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end