require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class NetworkReverseChainPractitionerRoleNetworkLocationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Example Test of _has:PractitionerRole:network:location'
      description %(
        Placeholder test for reverse chaining
      )
      
      id :davinci_plan_net_v110_network_reverse_chain_practitioner_role_network_location_search_test
      id :davinci_plan_net_v110_network_reverse_chain_practitioner_role_network_location_search_test
      input :practitioner_role_network_location_input,
        title: 'location field value for PractitionerRole',
        description: 'Value from the location field of a PractitionerRole
        that also references a Organization instance in its network field',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'practitioner_role_network_location_input',
          reverse_chain_param: 'location',
          reverse_chain_target: 'network',
          additional_resource_type: 'PractitionerRole'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'practitioner_role', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:network_resources] ||= {}
      end

      def scratch_chain_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      run do
        run_reverse_chain_search_test
      end
    end
  end
end
