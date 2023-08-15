require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PlannetNetworkPractitionerroleOrganizationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns PractitionerRole resources from Organization search by _revinclude=PractitionerRole:organization'
      description %(
        A server SHALL be capable of supporting _revIncludes for PractitionerRole:organization.

        This test will perform a search by _revinclude=PractitionerRole:organization and
        will pass if a PractitionerRole resource is found in the response.
      )

      id :davinci_plan_net_v110_v110_plannet_network_practitionerrole_organization_revinclude_search_test
  
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: ["_id"],
          revinclude_param: 'PractitionerRole:organization'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'PractitionerRole', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:plannet_network_resources] ||= {}
      end

      def scratch_revinclude_resources
        scratch[:PractitionerRole_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
