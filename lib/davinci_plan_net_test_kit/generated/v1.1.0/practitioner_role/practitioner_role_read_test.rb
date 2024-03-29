require_relative '../../../read_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class PractitionerRoleReadTest < Inferno::Test
      include DaVinciPlanNetTestKit::ReadTest

      title 'Server returns correct PractitionerRole resource from PractitionerRole read interaction'
      description 'A server SHALL support the PractitionerRole read interaction.'

      id :davinci_plan_net_v110_practitioner_role_read_test

      def resource_type
        'PractitionerRole'
      end

      def scratch_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      run do
        perform_read_test(all_scratch_resources)
      end
    end
  end
end
