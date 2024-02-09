require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class PractitionerRoleIncludePractitionerRoleEndpointSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns Endpoint resources from PractitionerRole search with _include=PractitionerRole:endpoint'
      description %(
        A server SHALL be capable of supporting _includes on search parameter PractitionerRole:endpoint.

        This test will perform a search on PractitionerRole with _include=PractitionerRole:endpoint 
        and the '_id' search parameter using an id with a reference to an Endpoint
        identified during instance gathering. The test will pass if at least one Endpoint 
        resource is found in the response and each instance that does is referenced by a returned PractitionerRole instance.
      )

      id :davinci_plan_net_v110_include_practitioner_role_practitioner_role_endpoint_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'PractitionerRole',
          search_param_names: [],
          include_param: 'PractitionerRole:endpoint',
          inc_param_sp: 'endpoint',
          additional_resource_type: 'Endpoint'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'endpoint', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:endpoint_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end