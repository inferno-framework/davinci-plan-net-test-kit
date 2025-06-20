require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class PractitionerReverseChainPractitionerRolePractitionerSpecialtySearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server capable of reverse chaining through PractitionerRole\'s specialty element'
      description %(
        Test will perform a search using the reverse chaining parameter 
        _has:PractitionerRole:practitioner:specialty
        using a value from either a previously identified PractitionerRole when 
        run from the suite level, or the "\'specialty\' value from a PractitionerRole 
        instance with \'practitioner\' populated" input when run at the group level. To validate the 
        returned instances, the test will perform a search 
        on the PractitionerRole resource type using the same specialty search 
        parameter and value and check that the instances returned by the tested search are all referenced
        by the practitioner element of instances returned by the additional search.
      )
      
      id :davinci_plan_net_v110_practitioner_reverse_chain_practitioner_role_practitioner_specialty_search_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@22'

      input :practitioner_role_practitioner_specialty_input,
        title: '\'specialty\' value from a PractitionerRole instance with \'practitioner\' populated',
        description: 'Single value from the \'specialty\' element of a PractitionerRole
        on an instance that also references a Practitioner instance in its \'practitioner\' element to be used for test 
        \'Server capable of reverse chaining through PractitionerRole\'s specialty element\' when run at the group level.',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Practitioner',
          search_param_names: [],
          input_name: 'practitioner_role_practitioner_specialty_input',
          reverse_chain_param: 'specialty',
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

      def scratch_additional_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      run do
        run_reverse_chain_search_test
      end
    end
  end
end
