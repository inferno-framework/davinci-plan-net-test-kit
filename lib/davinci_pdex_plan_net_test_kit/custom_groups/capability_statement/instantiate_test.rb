module DaVinciPDEXPlanNetTestKit
  class InstantiateTest < Inferno::Test
    id :davinci_pdex_plan_net_instantiate
    title 'Server instantiates Plan Net Server'
    description %(
        This test inspects the CapabilityStatement returned by the server to
        verify that the server instantiates http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server
      )
    uses_request :capability_statement

    run do
      assert_resource_type(:capability_statement)
      capability_statement = resource

      assert capability_statement.instantiates.include?('http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server'),
        "Server CapabilityStatement.instantiates does not include 'http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server'"
    end
  end
end
