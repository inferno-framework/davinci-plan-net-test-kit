require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PractitionerPractitionerRolePractitionerRevincludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns PractitionerRole resources from Practitioner search with _revinclude=PractitionerRole:practitioner'
      description %(
        A server SHALL be capable of supporting _revIncludes for PractitionerRole:practitioner.

        This test will perform a search with _revinclude=PractitionerRole:practitioner and
        will pass if a PractitionerRole resource is found in the response.
      )

      id :davinci_plan_net_v110_practitioner_practitioner_role_practitioner_revinclude_search_test
      input :practitioner_role_practitioner_input,
        title: 'PractitionerRole referenced Practitioner IDs',
        description: 'Comma separated list of Practitioner  IDs that are referenced by a PractitionerRole',
        optional: true
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Practitioner',
          search_param_names: [],
          input_name: 'practitioner_role_practitioner_input',
          revinclude_param: 'PractitionerRole:practitioner',
          rev_param_sp: 'practitioner',
          additional_resource_type: 'PractitionerRole'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'practitioner_role', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_resources] ||= {}
      end

      def scratch_revinclude_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
