require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class NetworkReverseChainPractitionerRoleNetworkLocationSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server capable of reverse chaining through PractitionerRole\'s location element'
      description %(
        Test will perform a search using the reverse chaining parameter 
        _has:PractitionerRole:network:location
        using a value from either a previously identified PractitionerRole when 
        run as a whole suite, or the "\'location\' value from a PractitionerRole 
        instance with \'network\' populated" input when run at the group level. To validate the 
        returned instances, the test will perform a search 
        on the PractitionerRole resource type using the same location search 
        parameter and value and check that the instances returned by the tested search are all referenced
        by the network element of instances returned by the additional search.
      )
      
      id :davinci_plan_net_v110_network_reverse_chain_practitioner_role_network_location_search_test
      input :practitioner_role_network_location_input,
        title: '\'location\' value from a PractitionerRole instance with \'network\' populated',
        description: 'Single value from the \'location\' element of a PractitionerRole
        on an instance that also references an Organization instance in its \'network\' element to be used for test 
        \'Server capable of reverse chaining through PractitionerRole\'s location element\' when run at the group level.',
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

      def scratch_additional_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      run do
        run_reverse_chain_search_test
      end
    end
  end
end
