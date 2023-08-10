require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PlannetOrganizationRevincludePractitionerroleNetworkSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns PractitionerRole resources from Organization search by _revinclude=PractitionerRole:network'
      description %(
        A server SHALL be capable of supporting _revIncludes for PractitionerRole:network.

        This test will perform a search by _revinclude=PractitionerRole:network and
        will pass if a PractitionerRole resource is found in the response.
      )

      id :us_core_v110_plannet_organization_revinclude_PractitionerRole_network_search_test
  
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          revinclude_param: 'PractitionerRole:network'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'PractitionerRole', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:plannet_organization_resources] ||= {}
      end

      def scratch_revinclude_resources
        scratch[:revinclude_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
