require_relative 'naming'
require_relative 'special_cases'

module DaVinciPDEXPlanNetTestKit
  class Generator
    class SuiteGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          new(ig_metadata, base_output_dir).generate
        end
      end

      attr_accessor :ig_metadata, :base_output_dir

      def initialize(ig_metadata, base_output_dir)
        self.ig_metadata = ig_metadata
        self.base_output_dir = base_output_dir
      end

      def version_specific_message_filters
        []
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'suite.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        "davinci_pdex_plan_net_test_suite.rb"
      end

      def class_name
        "DaVinciPDEXPlanNetTestSuite"
      end

      def module_name
        "DaVinciPDEXPlanNet#{ig_metadata.reformatted_version.upcase}"
      end

      def output_file_name
        File.join(base_output_dir, base_output_file_name)
      end

      def suite_id
        "davinci_pdex_plan_net_#{ig_metadata.reformatted_version}"
      end

      def title
        "DaVinci PDEX Plan Net #{ig_metadata.ig_version}"
      end

      def validator_env_name
        "#{ig_metadata.reformatted_version.upcase}_VALIDATOR_URL"
      end

      def ig_link
        "https://hl7.org/fhir/us/davinci-pdex-plan-net"
      end

      def generate
        File.open(output_file_name, 'w') { |f| f.write(output) }
      end

      def groups
        ig_metadata.ordered_groups
          .reject { |group| SpecialCases.exclude_group? group }
          .sort_by { |group| 
            case group.name
            when "plannet_Endpoint"
              1
            when "plannet_InsurancePlan"
              2
            when "plannet_OrganizationAffiliation"
              3
            when "plannet_PractitionerRole"
              4
            when "plannet_Practitioner"
              5
            when "plannet_HealthcareService"
              6
            when "plannet_Location"
              7
            when "plannet_Network"
              8
            when "plannet_Organization"
              9
            end
          }
      end

      def group_id_list
        @group_id_list ||=
          groups.map(&:id)
      end

      def group_file_list
        @group_file_list ||=
          groups.map { |group| group.file_name.delete_suffix('.rb') }
      end

      def capability_statement_file_name
        "../../custom_groups/#{ig_metadata.ig_version}/capability_statement_group"
      end

      def capability_statement_group_id
        "davinci_pdex_plan_net_#{ig_metadata.reformatted_version}_capability_statement"
      end
    end
  end
end
