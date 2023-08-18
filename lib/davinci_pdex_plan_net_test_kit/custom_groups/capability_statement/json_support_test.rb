module DaVinciPDEXPlanNetTestKit
  class JSONSupportTest < Inferno::Test
    id :davinci_pdex_plan_net_json_support
    title 'FHIR server capability states JSON support'
    description %(
      FHIR provides multiple [representation
      formats](https://www.hl7.org/fhir/formats.html) for resources, including
      JSON and XML. Plan Net profiles require servers to use the [JSON
      representation](https://www.hl7.org/fhir/json.html):

      [```The Plan Net Server **SHALL** Support json source formats for all Plan Net
      interactions.```](https://build.fhir.org/ig/HL7/davinci-pdex-plan-net/CapabilityStatement-plan-net.html#:~:text=Support%20json%20source%20formats%20for%20all%20Plan%2DNet%20interactions.)

      The FHIR conformance interaction require servers to describe which
      formats are available for clients to use. The server must explicitly
      state that JSON is supported. This is located in the [format
      element](https://www.hl7.org/fhir/capabilitystatement-definitions.html#CapabilityStatement.format)
      of the CapabilityStatement Resource.

      This test checks that one of the following values are located in the
      format field.

      * json
      * application/json
      * application/fhir+json
    )
    uses_request :capability_statement

    run do
      assert_resource_type(:capability_statement)

      json_formats = ['json', 'application/json', 'application/fhir+json']
      server_formats = resource.format

      assert server_formats.any? { |format| json_formats.include? format },
              'CapabilityStatement does not state support for JSON'
    end
  end
end
