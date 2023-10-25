require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PractitionerReverseChainPractitionerRolePractitionerRoleSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server capable of reverse chaining through PractitionerRole\'s role field'
      description %(
        A server SHALL support reverse chaining.

        Test will use the query _has:PractitionerRole:practitioner:role to test
        the server for reverse chaining capability.  This test does not validate returned resources at this time.
      )
      
      id :davinci_plan_net_v110_practitioner_reverse_chain_practitioner_role_practitioner_role_search_test
      input :practitioner_role_practitioner_role_input,
        title: 'role field value for PractitionerRole',
        description: 'Value from the role field of a PractitionerRole
        that also references a Practitioner instance in its practitioner field',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Practitioner',
          search_param_names: [],
          input_name: 'practitioner_role_practitioner_role_input',
          reverse_chain_param: 'role',
          reverse_chain_target: 'practitioner',
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
        scratch[:practitioner_resources] ||= {}
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
