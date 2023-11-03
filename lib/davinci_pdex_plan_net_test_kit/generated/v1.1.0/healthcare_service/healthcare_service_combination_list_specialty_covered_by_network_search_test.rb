require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class HealthcareServiceCombinationListSpecialtyCoveredByNetworkSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server capable of combination search, e.g. being able to List all instances of a specific specialty service covered under a network'
      description %(
        A server SHALL support searching with a combination of parameters.  This specific test will attempt to list all HealthcareService reosurces with a specific specialty covered under a specific network
      )
      
      id :davinci_plan_net_v110_healthcare_service_combination_list_specialty_covered_by_network_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'HealthcareService',
          search_param_names: ['specialty'],
          input_name: 'combination_list_specialty_covered_by_network_input',
          reverse_chain_param: 'network',
          reverse_chain_target: 'service',
          additional_resource_type: 'OrganizationAffiliation',
          combination_search: true
        )
      end

      
      input :combination_list_specialty_covered_by_network_input,
        title: 'Combination Search Reverse Chain',
        description: 'Network value of an OrganizationAffiliation instance that also references a HealthcareService instance in its service element',
        optional: true
      
      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'organization_affiliation', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:organization_affiliation_resources] ||= {}
      end

      run do
        run_combination_search_test
      end
    end
  end
end
