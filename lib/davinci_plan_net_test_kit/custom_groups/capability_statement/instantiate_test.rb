module DaVinciPlanNetTestKit
  class InstantiateTest < Inferno::Test
    id :davinci_plan_net_instantiate
    title 'Server instantiates Plan Net Server'
    description %(
        This test inspects the CapabilityStatement returned by the server to
        verify that the server instantiates http://hl7.org/fhir/us/davinci-pdex-plan-net/CapabilityStatement/plan-net
      )
    uses_request :capability_statement

    run do
      assert_resource_type(:capability_statement)
      capability_statement = resource

      assert capability_statement.instantiates.include?('http://hl7.org/fhir/us/davinci-pdex-plan-net/CapabilityStatement/plan-net'),
        "Server CapabilityStatement.instantiates does not include 'http://hl7.org/fhir/us/davinci-pdex-plan-net/CapabilityStatement/plan-net'"
    end
  end
end
