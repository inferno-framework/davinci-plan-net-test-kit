require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationLocationOrganizationIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Organization resources from Location search by _include=Location:organization'
      description %(
        A server SHALL be capable of supporting _includes for Location:organization.

        This test will perform a search by _include=Location:organization and
        will pass if a Organization resource is found in the response.
      )

      id :davinci_plan_net_v110_v110_location_location_organization_include_search_test
      input :location_organization_input,
        title: 'IDs of Location that have Organization reference(s)',
        description: 'Comma separated list of Location IDs that reference by a Organization'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          input_name: 'location_organization_input',
          include_param: 'Location:organization',
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
        scratch[:location_resources] ||= {}
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