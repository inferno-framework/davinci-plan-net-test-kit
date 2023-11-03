require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationRevincludeEndpointOrganizationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Endpoint resources from Organization search with _revinclude=Endpoint:organization'
      description %(
        A server SHALL be capable of supporting searches _revIncludes on search parameter Endpoint:organization.

        This test will perform a search on Organization with _revinclude=Endpoint:organization and the '_id'
        search parameter using an id previoiusly identified when the whole test suite is run or an id provided
        in the "Organization instance ids referenced in Endpoint.organization" input if run at the group level.
        The test will pass if at least one Endpoint resource found in the response
        and each instance that does includes a reference to the Organization with the searched id.
      )

      id :davinci_plan_net_v110_revinclude_organization_endpoint_organization_search_test
      input :endpoint_organization_input,
        title: 'Organization instance ids referenced in Endpoint.organization',
        description: %(Comma separated list of Organization instance ids that are referenced by an Endpoint
        instance in its organization element. Used for test "Server returns Endpoint resources from Organization search with _revinclude=Endpoint:organization"
        when run at the group level.),
        optional: true
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'endpoint_organization_input',
          revinclude_param: 'Endpoint:organization',
          rev_param_sp: 'organization',
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
        scratch[:organization_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:endpoint_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
