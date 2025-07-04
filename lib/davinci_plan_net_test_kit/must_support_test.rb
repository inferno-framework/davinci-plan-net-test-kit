require_relative 'fhir_resource_navigation'

module DaVinciPlanNetTestKit
  module MustSupportTest
    extend Forwardable
    include FHIRResourceNavigation

    def_delegators 'self.class', :metadata

    def all_scratch_resources
      scratch_resources[:all]
    end

    def perform_must_support_test(resources)
      skip_if resources.blank?, "No #{resource_type} resources were found"

      skip { assert_must_support_elements_present(resources, nil, metadata:) }
    end
  end
end
