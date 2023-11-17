require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class PractitionerRoleForwardChainServiceLocationSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server capable of forward chaining with service.location'
      description %(
        A server SHALL be capable of supporting chaining for location through the search parameter service
        for the Practitioner_role profile.

        This test will perform a search with service.location using a value
        in the location element on an instance found during _include tests executed
        previously during this sequence. To validate the returned instances, the test will perform a search 
        on the HealthcareService resource type using the same location search 
        parameter and value and check that this search contains any instances referenced through the 
        service element of instances returned by the tested search.
      )

      id :davinci_plan_net_v110_forward_chain_service_location_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'PractitionerRole',
          search_param_names: [],
          chain_param: 'location',
          chain_param_base: 'service',
          additional_resource_type: 'HealthcareService'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'healthcare_service', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      run do
        run_forward_chain_search_test
      end
    end
  end
end