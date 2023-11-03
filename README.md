# DaVinci PDEX Plan Net v1.1.0 Test Kit

The Plan Net STU 1.1.0 Server Test Kit validates the conformance of a server 
implementation to the Plan Net STU 1.1.0 FHIR IG. Inferno will act as a client 
and make a series of requests to the server under test. The responses will be 
checked for conformance to the Plan Net IG requirements individually and used 
in aggregate to determine whether required features and functionality are present.

This test kit is [open source](#license) and freely available for use or
adoption by the health IT community including EHR vendors, health app
developers, and testing labs. It is built using the [Inferno
Framework](https://inferno-framework.github.io/). The Inferno Framework is
designed for reuse and aims to make it easier to build test kits for any
FHIR-based data exchange.

## Status

These tests are a **DRAFT** intended to allow Plan Net server implementers to perform 
preliminary checks of their servers against Plan Net IG requirements and provide 
feedback to ONC on the tests. Future versions of these tests may validate other 
requirements and may change how these are tested.

The test kit current tests the following requirements:
- Support for Must Support Elements
- json Support
- Support for all Plan Net Profiles
- Read Interaction
- Individual Search Parameters
- _include Searches
- _revinclude Searches
- Forward Chain Searches
- Reverse Chain Searches
- Search Parameters in Combination

See the test descriptions within the test kit for detail on the specific 
validations performed as a part of testing these requirements. 

Additional details on the IG requirements that underlie this test, including those 
that are not currently tested, can be found in [this spreadsheet](lib/davinci_pdex_plan_net_test_kit/igs/Plan%20Net%20Requirements%20Interpretation.xlsx). The spreadsheet includes
- a list of requirements extracted from the IG
- the requirements tested by this DRAFT test kit
- an analysis of which requirements are testable, including areas where testable requirements are weak or unclear
- the approach taken to testing each tested requirement
- a map of requirements to test kit test ids
- open questions for IG authors seeking to clarify the IG requirements

## How to Run

Use either of the following methods to run the test suite against a Plan Net server.
If you would like to try out the tests but don’t have a Plan Net server implementation, 
you can use the publicly available reference implementation available at FHIR URL 
https://plan-net-ri.davinci.hl7.org/fhir.

### ONC Hosted Instance

You can run these tests via the [ONC Inferno](https://inferno.healthit.gov/suites/) website by choosing the “DaVinci PDEX Plan Net v1.1.0” test suite.

### Local Inferno Instance

- download the source code from this repository
- Open a terminal in the directory containing the downloaded code
- In the terminal, run `setup.sh`
- In the terminal, run `run.sh`
- Use a web browser to navigate to `http://localhost`

## Providing Feedback and Reporting Issues

We welcome feedback on the tests, including but not limited to the following areas:
- Validation logic, such as potential bugs, lax checks, and unexpected failures.
- Requirements coverage, such as requirements that have been missed, tests that necessitate features that the IG does not require, or other issues with the [interpretation](lib/davinci_pdex_plan_net_test_kit/igs/Plan%20Net%20Requirements%20Interpretation.xlsx) of the IG's requirements.
- User experience, such as confusing or missing information in the test UI.

Please report any issues with this set of tests in the issues section of this repository.

## License
Copyright 2023 The MITRE Corporation

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

## Trademark Notice

HL7, FHIR and the FHIR [FLAME DESIGN] are the registered trademarks of Health
Level Seven International and their use does not constitute endorsement by HL7.
