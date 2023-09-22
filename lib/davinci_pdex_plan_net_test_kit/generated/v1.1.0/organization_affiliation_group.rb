require_relative 'organization_affiliation/organization_affiliation_no_params_search_test'
require_relative 'organization_affiliation/organization_affiliation_read_test'
require_relative 'organization_affiliation/organization_affiliation_primary_organization_search_test'
require_relative 'organization_affiliation/organization_affiliation_participating_organization_search_test'
require_relative 'organization_affiliation/organization_affiliation_location_search_test'
require_relative 'organization_affiliation/organization_affiliation_service_search_test'
require_relative 'organization_affiliation/organization_affiliation_network_search_test'
require_relative 'organization_affiliation/organization_affiliation_endpoint_search_test'
require_relative 'organization_affiliation/organization_affiliation_role_search_test'
require_relative 'organization_affiliation/organization_affiliation_specialty_search_test'
require_relative 'organization_affiliation/organization_affiliation_id_search_test'
require_relative 'organization_affiliation/organization_affiliation_lastupdated_search_test'
require_relative 'organization_affiliation/organization_affiliation_organization_affiliation_primary_organization_include_search_test'
require_relative 'organization_affiliation/organization_affiliation_organization_affiliation_participating_organization_include_search_test'
require_relative 'organization_affiliation/organization_affiliation_organization_affiliation_location_include_search_test'
require_relative 'organization_affiliation/organization_affiliation_organization_affiliation_service_include_search_test'
require_relative 'organization_affiliation/organization_affiliation_organization_affiliation_endpoint_include_search_test'
require_relative 'organization_affiliation/organization_affiliation_organization_affiliation_network_include_search_test'
require_relative 'organization_affiliation/organization_affiliation_primary_organization_type_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_primary_organization_address_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_primary_organization_name_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_primary_organization_partof_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_participating_organization_type_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_participating_organization_address_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_participating_organization_name_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_participating_organization_partof_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_location_address_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_location_address_postalcode_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_location_address_city_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_location_address_state_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_location_organization_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_location_type_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_service_service_category_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_service_organization_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_service_location_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_network_name_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_network_partof_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_endpoint_organization_forward_chain_search_test'
require_relative 'organization_affiliation/organization_affiliation_validation_test'
require_relative 'organization_affiliation/organization_affiliation_must_support_test'
require_relative 'organization_affiliation/organization_affiliation_reference_resolution_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationAffiliationGroup < Inferno::TestGroup
      title 'Plan-Net OrganizationAffiliation Tests'
      short_description 'Verify support for the server capabilities required by the Plan-Net OrganizationAffiliation.'
      description %(
  # Background

The Plan-Net OrganizationAffiliation sequence verifies that the system under test is
able to provide correct responses for OrganizationAffiliation queries. These queries
must return resources conforming to the Plan-Net OrganizationAffiliation profile as
specified in the Plan Net v1.1.0 Implementation Guide.

# Testing Methodology

## Instance Gathering

Inferno will first identify and obtain a set of instances to use for the rest
of the tests, requiring at least one instances to be identified for the test to pass. 
Instances to gather are indentified in two ways. One or both will be used,
depending on user input.

### Parameterless searches 
Instances can be gathered using a query requesting all instances of OrganizationAffiliation 
(e.g., `GET [FHIR Endpoint]/OrganizationAffiliation`). Gathering through this method is controlled 
by the following input fields (used for all profiles):
- _Use parameterless searches to identify instances?_: 
  parameterless searches can be disabled using this input field if, for example, 
  the server under test does not support them, or not all instances on the server 
  should be expected to conform to Plan Net profiles. In this case the user **MUST**
  provide specific instance ids to gather.
- _Maximum number of instances to gather using parameterless searches_: sets an upper 
  bound on the number of instances Inferno will gather from parameterless searches.
- _Maximum pages of results to consider when using parameterless searches_: sets an upper bound 
  on the number of pages of search results Inferno will load when gathering instances 
  using parameterless searches.

### User-provided instance ids

If ids are listed in the _Ids of instances of Plan-Net OrganizationAffiliation_ optional input field, 
they will be read and included in the set of gathered instances.


## Searching
This test sequence will perform each required search associated
with this resource. This sequence will perform searches with the
following parameters:

* primary-organization
* participating-organization
* location
* service
* network
* endpoint
* role
* specialty
* _id
* _lastUpdated

### Search Parameters
The first search uses the selected Plan-Net OrganizationAffiliation(s) from the prior launch
sequence. Any subsequent searches will look for its parameter values
from the results of the first search. For example, the `identifier`
search in the Plan-Net OrganizationAffiliation sequence is performed by looking for an existing
`OrganizationAffiliation.identifier` value from an instance identified during
the instance gathering step. If a value cannot be found this way, the search is skipped.

### Search Validation
Inferno will retrieve up to the first 20 bundle pages of the reply for
OrganizationAffiliation resources. Each of
these resources is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
for example, if a Plan-Net OrganizationAffiliation search for `primary-organization=X`
returns a Plan-Net OrganizationAffiliation where `primary-organization!=X`


## _include Requirement Testing
This test sequence will perform each required _include search associated
with this resource. This sequence will perform searches with the
following includes:

* OrganizationAffiliation:primary-organization
* OrganizationAffiliation:participating-organization
* OrganizationAffiliation:location
* OrganizationAffiliation:service
* OrganizationAffiliation:endpoint
* OrganizationAffiliation:network

All _include searches will look for candidate IDs from the results of 
instance gathering.  Each search will use a Plan-Net OrganizationAffiliation ID and the include parameter.
The return is scanned to find any of the expected additional resource.




## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements populated at least once. If at
least one cannot be found, the test will fail. The test will look
through the Plan-Net OrganizationAffiliation instances identified during instance gathering
for these elements.

## Profile Validation
Each resource identified during instance gathering is expected to conform to
the [Plan-Net OrganizationAffiliation](http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-OrganizationAffiliation). Each element is checked against
teminology binding and cardinality requirements.

Elements with a required binding are validated against their bound
ValueSet. If the code/system in the element is not part of the ValueSet,
then the test will fail.

## Reference Validation
At least one instance of each external reference in elements marked as
"must support" within the resources provided by the system must resolve.
The test will attempt to read each reference found and will fail if no
read succeeds.

      )

      id :davinci_pdex_plan_net_v110_organization_affiliation
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'organization_affiliation', 'metadata.yml'), aliases: true))
      end
  
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_no_params_search_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_read_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_primary_organization_search_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_participating_organization_search_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_location_search_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_service_search_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_network_search_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_endpoint_search_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_role_search_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_specialty_search_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation__id_search_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation__lastUpdated_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_organization_affiliation_primary_organization_include_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_organization_affiliation_participating_organization_include_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_organization_affiliation_location_include_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_organization_affiliation_service_include_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_organization_affiliation_endpoint_include_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_organization_affiliation_network_include_search_test
      test from: :davinci_plan_net_v110_primary_organization_type_forward_chain_search_test
      test from: :davinci_plan_net_v110_primary_organization_address_forward_chain_search_test
      test from: :davinci_plan_net_v110_primary_organization_name_forward_chain_search_test
      test from: :davinci_plan_net_v110_primary_organization_partof_forward_chain_search_test
      test from: :davinci_plan_net_v110_participating_organization_type_forward_chain_search_test
      test from: :davinci_plan_net_v110_participating_organization_address_forward_chain_search_test
      test from: :davinci_plan_net_v110_participating_organization_name_forward_chain_search_test
      test from: :davinci_plan_net_v110_participating_organization_partof_forward_chain_search_test
      test from: :davinci_plan_net_v110_location_address_forward_chain_search_test
      test from: :davinci_plan_net_v110_location_address_postalcode_forward_chain_search_test
      test from: :davinci_plan_net_v110_location_address_city_forward_chain_search_test
      test from: :davinci_plan_net_v110_location_address_state_forward_chain_search_test
      test from: :davinci_plan_net_v110_location_organization_forward_chain_search_test
      test from: :davinci_plan_net_v110_location_type_forward_chain_search_test
      test from: :davinci_plan_net_v110_service_service_category_forward_chain_search_test
      test from: :davinci_plan_net_v110_service_organization_forward_chain_search_test
      test from: :davinci_plan_net_v110_service_location_forward_chain_search_test
      test from: :davinci_plan_net_v110_network_name_forward_chain_search_test
      test from: :davinci_plan_net_v110_network_partof_forward_chain_search_test
      test from: :davinci_plan_net_v110_endpoint_organization_forward_chain_search_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_validation_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_must_support_test
      test from: :davinci_pdex_plan_net_v110_organization_affiliation_reference_resolution_test
    end
  end
end
