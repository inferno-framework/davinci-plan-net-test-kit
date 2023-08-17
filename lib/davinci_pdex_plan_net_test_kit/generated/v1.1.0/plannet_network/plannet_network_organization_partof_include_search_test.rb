require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PlannetNetworkOrganizationPartofIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Organization resources from Organization search by _include=Organization:partof'
      description %(
        A server SHALL be capable of supporting _includes for Organization:partof.

        This test will perform a search by _include=Organization:partof and
        will pass if a Organization resource is found in the response.
      )

      id :davinci_plan_net_v110_v110_plannet_network_organization_partof_include_search_test
      input :organization_partof_input,
        title: 'IDs of Organization that have Organization reference(s)',
        description: 'Comma separated list of Organization IDs that reference by a Organization'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'organization_partof_input',
          include_param: 'Organization:partof',
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
        scratch[:plannet_network_resources] ||= {}
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