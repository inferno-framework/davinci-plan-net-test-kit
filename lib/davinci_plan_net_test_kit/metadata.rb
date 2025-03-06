require_relative 'version'

module DaVinciPlanNetTestKit
  class Metadata < Inferno::TestKit
    id :davinci_plan_net_test_kit
    title 'Da Vinci Plan Net Test Kit'
    suite_ids [ 'davinci_plan_net_server_v110' ]
    tags ['Da Vinci']
    last_updated ::DaVinciPlanNetTestKit::LAST_UPDATED
    version ::DaVinciPlanNetTestKit::VERSION
    maturity 'Low'
    authors ['Karl Naden']
    repo 'https://github.com/inferno-framework/davinci-plan-net-test-kit'
    description <<~DESCRIPTION
        The DaVinci Plan Net Test Kit validates the conformance of a server
        implementation to version 1.1.0 of the
        [DaVinci PDEX Plan Net Implementation Guide](http://hl7.org/fhir/us/davinci-pdex-plan-net/STU1.1).

        <!-- break -->

        Inferno will act as a client and make a series of requests to the
        server under test. The responses will be checked for conformance
        to the Plan Net IG requirements individually and used in aggregate
        to determine whether required features and functionality are present.

        The test kit currently tests the following requirements:

         - Support for Must Support Elements
         - JSON Support
         - Support for all Plan Net Profiles
         - Read Interaction
         - Individual Search Parameters
         - _include Searches
         - _revinclude Searches
         - Forward Chain Searches
         - Reverse Chain Searches
         - Search Parameters in Combination

        The DaVinci Plan Net Test Kit is built using the
        [Inferno Framework](https://inferno-framework.github.io/).
        The Inferno Framework is designed for reuse and aims to make it easier
        to build test kits for any FHIR-based data exchange.

        ### Known Limitations

        The following areas of the IG are not fully tested in this draft version
        of the test kit:

         - All search parameter combinations: the tests check for support of only
           specific combinations of search parameters driven by
           [anticipated searches listed in the IG](http://hl7.org/fhir/us/davinci-pdex-plan-net/implementation.html#Representing).
         - Response classes: the Plan Net IG lists HTTP response codes that the
           server needs to be able to return, but does not indicate specific
           criteria for requests that elicit these status codes.

        Additional details on these and other areas where the tests may not align
        with the IGs requirements, see this requirements analysis spreadsheet.

        ## Reporting Issues

        Please report any issues with this set of tests in the
        [GitHub Issues](https://github.com/inferno-framework/davinci-plan-net-test-kit/issues)
        section of this repository.
    DESCRIPTION
  end
end
