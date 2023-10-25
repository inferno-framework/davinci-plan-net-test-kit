RSpec.describe DaVinciPDEXPlanNetTestKit::SearchTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('davinci_pdex_plan_net_v110') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:test_session) { repo_create(:test_session, test_suite_id: suite.id) }
  let(:url) { 'http://example.com/fhir' }
  let(:error_outcome) { FHIR::OperationOutcome.new(issue: [{ severity: 'error' }]) }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(
        test_session_id: test_session.id,
        name: name,
        value: value,
        type: runnable.config.input_type(name)
      )
    end
    Inferno::TestRunner.new(test_session: test_session, test_run: test_run).run(runnable)
  end

  describe '_include search' do
    let (:include_test) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::EndpointIncludeEndpointOrganizationSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:include_test_no_scratch) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::EndpointIncludeEndpointOrganizationSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:include_test_no_reference) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::EndpointIncludeEndpointOrganizationSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:include_test_only_url) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::EndpointIncludeEndpointOrganizationSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:endpoint_local) {
      FHIR::Endpoint.new(
        id: 'endpoint-local-reference',
        managingOrganization: {
          reference: "Organization/acme"
        }
      )
    }
    let (:endpoint_url) {
      FHIR::Endpoint.new(
        id: 'endpoint-url',
        managingOrganization: {
          reference: "http://example.com/Organization/ecorp"
        }
      )
    }
    let (:endpoint_no_reference) {
      FHIR::Endpoint.new(
        id: 'endpoint-no-reference',
      )
    }
    let (:organization_local) {
      FHIR::Organization.new(
        id: 'acme'
      )
    }
    let (:organization_url) {
      FHIR::Organization.new(
        id: 'ecorp'
      )
    }
    let (:organization_unreferenced) {
      FHIR::Organization.new(
        id: 'org-3'
      )
    }
    let (:bundle ) {
      FHIR::Bundle.new(
        entry: []
      )
    }
    let (:test_scratch) { {
      all: [endpoint_local, endpoint_url]
    } }
    let (:only_url_scratch) { {
      all: [endpoint_url]
    } }
    let (:empty_scratch) { {
      all: []
    }}
    let (:no_reference_scratch){ {
      all: [endpoint_no_reference]
    }}

    before do
      allow_any_instance_of(include_test).to receive(:scratch_resources).and_return(test_scratch)
      allow_any_instance_of(include_test_no_scratch).to receive(:scratch_resources).and_return(empty_scratch)
      allow_any_instance_of(include_test_no_reference).to receive(:scratch_resources).and_return(no_reference_scratch)
      allow_any_instance_of(include_test_only_url).to receive(:scratch_resources).and_return(only_url_scratch)
      stub_request(:get, "#{url}/Endpoint")
        .to_return(status: 200, body: FHIR::Bundle.new.to_json)
    end

    it 'passes when references and included Resources are exact match' do
      bundle.entry.concat([ { resource: endpoint_local }, {resource: organization_local }])
      stub_request(:get, "#{url}/Endpoint?_id=#{endpoint_local.id}&_include=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(include_test, url: url)
      expect(result.result).to eq('pass')
    end

    it 'passes when references are a url and included resources are exact match' do
      bundle.entry.concat([ { resource: endpoint_url }, {resource: organization_url }])
      stub_request(:get, "#{url}/Endpoint?_id=#{endpoint_url.id}&_include=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(include_test_only_url, url: url)
      expect(result.result).to eq('pass')
    end

    it 'fails when returned additional resources are not referenced' do
      bundle.entry.concat([ { resource: endpoint_local }, {resource: organization_url }])
      stub_request(:get, "#{url}/Endpoint?_id=#{endpoint_local.id}&_include=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(include_test, url: url)
      expect(result.result).to eq('fail')
    end

    it 'fails when returning both referenced and unreferenced resources' do
      bundle.entry.concat([ { resource: endpoint_local }, {resource: organization_local }, {resource: organization_unreferenced}])
      stub_request(:get, "#{url}/Endpoint?_id=#{endpoint_local.id}&_include=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(include_test, url: url)
      expect(result.result).to eq('fail')
    end

    it 'Fails when server returns a non 200 status code and resulting message displays returned status code' do
      bundle.entry.concat([ { resource: endpoint_local }, {resource: organization_local }, {resource: organization_unreferenced}])
      stub_request(:get, "#{url}/Endpoint?_id=#{endpoint_local.id}&_include=Endpoint:organization")
        .to_return(status: 400, body: bundle.to_json)

      result = run(include_test, url: url)
      expect(result.result).to eq('fail')
      expect(result.result_message).to eq('Unexpected response status: expected 200, but received 400')
    end

    it 'skips when no additional resources are returned' do
      bundle.entry.concat([ { resource: endpoint_local } ])
      stub_request(:get, "#{url}/Endpoint?_id=#{endpoint_local.id}&_include=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(include_test, url: url)
      expect(result.result).to eq('skip')
    end

    it 'skips when scratch is empty' do
      result = run(include_test_no_scratch, url: url)
      expect(result.result).to eq('skip')
    end

    it 'skips when scratch does not contain base resources that have desired reference' do
      result = run(include_test_no_reference, url: url)
      expect(result.result).to eq('skip')
    end
  end

  describe '_revinclude search' do
    let (:revinclude_test) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::OrganizationRevincludeEndpointOrganizationSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:revinclude_test_no_scratch) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::OrganizationRevincludeEndpointOrganizationSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:revinclude_test_no_reference) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::OrganizationRevincludeEndpointOrganizationSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:revinclude_test_only_url) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::OrganizationRevincludeEndpointOrganizationSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:endpoint_local) {
      FHIR::Endpoint.new(
        id: 'endpoint-local-reference',
        managingOrganization: {
          reference: "Organization/acme"
        }
      )
    }
    let (:endpoint_url) {
      FHIR::Endpoint.new(
        id: 'endpoint-url',
        managingOrganization: {
          reference: "http://example.com/Organization/ecorp"
        }
      )
    }
    let (:endpoint_no_reference) {
      FHIR::Endpoint.new(
        id: 'endpoint-no-reference',
      )
    }
    let (:organization_local) {
      FHIR::Organization.new(
        id: 'acme'
      )
    }
    let (:organization_url) {
      FHIR::Organization.new(
        id: 'ecorp'
      )
    }
    let (:organization_unreferenced) {
      FHIR::Organization.new(
        id: 'org-3'
      )
    }
    let (:bundle ) {
      FHIR::Bundle.new(
        entry: []
      )
    }
    let (:test_scratch) { {
      all: [endpoint_local, endpoint_url]
    } }
    let (:only_url_scratch) { {
      all: [endpoint_url]
    } }
    let (:empty_scratch) { {
      all: []
    }}
    let (:no_reference_scratch){ {
      all: [endpoint_no_reference]
    }}

    before do
      allow_any_instance_of(revinclude_test).to receive(:scratch_revinclude_resources).and_return(test_scratch)
      allow_any_instance_of(revinclude_test_no_scratch).to receive(:scratch_revinclude_resources).and_return(empty_scratch)
      allow_any_instance_of(revinclude_test_no_reference).to receive(:scratch_revinclude_resources).and_return(no_reference_scratch)
      allow_any_instance_of(revinclude_test_only_url).to receive(:scratch_revinclude_resources).and_return(only_url_scratch)
      stub_request(:get, "#{url}/Organization")
        .to_return(status: 200, body: FHIR::Bundle.new.to_json)
    end

    it 'passes when references and included Resources are exact match' do
      bundle.entry.concat([ {resource: organization_local }, {resource: endpoint_local }])
      stub_request(:get, "#{url}/Organization?_id=Organization/#{organization_local.id}&_revinclude=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(revinclude_test, url: url)
      expect(result.result).to eq('pass')
    end

    it 'passes when references are a url and included resources are exact match' do
      bundle.entry.concat([ { resource: endpoint_url }, {resource: organization_url }])
      stub_request(:get, "#{url}/Organization?_id=#{endpoint_url.managingOrganization.reference}&_revinclude=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(revinclude_test_only_url, url: url)
      expect(result.result).to eq('pass')
    end

    it 'passes with empty scratch but given an input by user for revinclude base' do
      bundle.entry.concat([ { resource: endpoint_url }, {resource: organization_url }])
      stub_request(:get, "#{url}/Organization?_id=#{organization_url.id}&_revinclude=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(revinclude_test_no_scratch, url: url, endpoint_organization_input: organization_url.id)
      expect(result.result).to eq('pass')
    end

    it 'fails when returned additional resources are not referenced' do
      bundle.entry.concat([ {resource: organization_local }, {resource: endpoint_url}])
      stub_request(:get, "#{url}/Organization?_id=Organization/#{organization_local.id}&_revinclude=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(revinclude_test, url: url)
      expect(result.result).to eq('fail')
    end

    it 'fails when returning both referenced and unreferenced resources' do
      bundle.entry.concat([ { resource: endpoint_local }, {resource: organization_local }, {resource: endpoint_url}])
      stub_request(:get, "#{url}/Organization?_id=Organization/#{organization_local.id}&_revinclude=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(revinclude_test, url: url)
      expect(result.result).to eq('fail')
    end

    it 'Fails when server returns a non 200 status code and resulting message displays returned status code' do
      bundle.entry.concat([ {resource: organization_local }, {resource: endpoint_local }])
      stub_request(:get, "#{url}/Organization?_id=Organization/#{organization_local.id}&_revinclude=Endpoint:organization")
        .to_return(status: 400, body: bundle.to_json)

      result = run(revinclude_test, url: url)
      expect(result.result).to eq('fail')
      expect(result.result_message).to eq('Unexpected response status: expected 200, but received 400')
    end

    it 'skips when no additional resources are returned' do
      stub_request(:get, "#{url}/Organization?_id=Organization/#{organization_local.id}&_revinclude=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(revinclude_test, url: url)
      expect(result.result).to eq('skip')
    end

    it 'skips when scratch is empty and no input given' do
      result = run(revinclude_test_no_scratch, url: url)
      expect(result.result).to eq('skip')
    end

    it 'skips when scratch does not contain base resources that have desired reference' do
      result = run(revinclude_test_no_reference, url: url)
      expect(result.result).to eq('skip')
    end
  end

  describe 'forward chaining tests' do
    let (:forward_chain_test) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::EndpointForwardChainOrganizationTypeSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:forward_chain_test_no_scratch) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::EndpointForwardChainOrganizationTypeSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:forward_chain_test_no_type) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::EndpointForwardChainOrganizationTypeSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:forward_chain_test_non_prvgrp_type) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::EndpointForwardChainOrganizationTypeSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:endpoint_local) {
      FHIR::Endpoint.new(
        id: 'endpoint-local-reference',
        managingOrganization: {
          reference: "Organization/acme"
        }
      )
    }
    let (:endpoint_url) {
      FHIR::Endpoint.new(
        id: 'endpoint-url',
        managingOrganization: {
          reference: "http://example.com/Organization/ecorp"
        }
      )
    }
    let (:endpoint_local_references_non_prvgrp) {
      FHIR::Endpoint.new(
        id: 'endpoint-local-non-prvgrp',
        managingOrganization: {
          reference: "Organization/not-prvgrp"
        }
      )
    }
    let (:endpoint_url_references_non_prvgrp) {
      FHIR::Endpoint.new(
        id: 'endpoint-url-non-prvgrp',
        managingOrganization: {
          reference: "http://example.com/Organization/not-prvgrp"
        }
      )
    }
    let (:endpoint_referencing_organization_without_type) {
      FHIR::Endpoint.new(
        id: 'endpoint-reference-org-without-type',
        managingOrganization: {
          reference: "Organization/no-type"
        }
      )
    }
    let (:organization_acme_type_prvgrp) {
      FHIR::Organization.new(
        id: 'acme',
        type: [ { 
          coding: [ {
            system: 'http://hl7.org/fhir/us/davinci-pdex-plan-net/CodeSystem/OrgTypeCS',
            code: 'prvgrp',
            display: 'Provider Group'
          } ]
        } ]
      )
    }
    let (:organization_ecorp_type_prvgrp) {
      FHIR::Organization.new(
        id: 'ecorp',
        type: [ { 
          coding: [ {
            system: 'http://hl7.org/fhir/us/davinci-pdex-plan-net/CodeSystem/OrgTypeCS',
            code: 'prvgrp',
            display: 'Provider Group'
          } ]
        } ]
      )
    }
    let (:organization_type_anomaly) {
      FHIR::Organization.new(
        id: 'not-prvgrp',
        type: [ { 
          coding: [ {
            system: 'http://hl7.org/fhir/us/davinci-pdex-plan-net/CodeSystem/OrgTypeCS',
            code: 'anomaly',
            display: 'Not a real group'
          } ]
        } ]
      )
    }
    let (:organization_no_type) {
      FHIR::Organization.new(
        id: 'no-type',
        name: 'Typeless Organization'
      )
    }
    let (:bundle) {
      FHIR::Bundle.new(
        entry: []
      )
    }
    let (:prvgrp_bundle) {
      FHIR::Bundle.new(
        entry: [{resource: organization_acme_type_prvgrp}, {resource: organization_ecorp_type_prvgrp}]
      )
    }
    let (:organization_bundle_with_multiple_types) {
      FHIR::Bundle.new(
        entry: [{resource: organization_acme_type_prvgrp}, {resource: organization_type_anomaly}]
      )
    }
    let (:test_scratch) { {
      all: [organization_acme_type_prvgrp, organization_ecorp_type_prvgrp]
    } }
    let (:only_non_prvgrp_scratch) { {
      all: [organization_type_anomaly]
    } }
    let (:empty_scratch) { {
      all: []
    }}
    let (:no_reference_with_type_scratch){ {
      all: [organization_no_type]
    }}

    before do
      allow_any_instance_of(forward_chain_test).to receive(:scratch_chain_resources).and_return(test_scratch)
      allow_any_instance_of(forward_chain_test_no_scratch).to receive(:scratch_chain_resources).and_return(empty_scratch)
      allow_any_instance_of(forward_chain_test_no_type).to receive(:scratch_chain_resources).and_return(no_reference_with_type_scratch)
      allow_any_instance_of(forward_chain_test_non_prvgrp_type).to receive(:scratch_chain_resources).and_return(only_non_prvgrp_scratch)
      stub_request(:get, "#{url}/Organization?type=prvgrp")
        .to_return(status: 200, body: prvgrp_bundle.to_json)
    end

    it 'Passes when server returns all base resources that reference Additional resource locally AND/OR url with matching field value' do
      bundle.entry.concat([ {resource: endpoint_local }, {resource: endpoint_url }])
      stub_request(:get, "#{url}/Endpoint?organization.type=prvgrp")
        .to_return(status: 200, body: bundle.to_json)
      
      result = run(forward_chain_test, url: url)
      expect(result.result).to eq('pass')
    end
    
    it 'Fails when server returns base resources with references to additional resource without matching field value' do
      bundle.entry.concat([ {resource: endpoint_local }, {resource: endpoint_url }, {resource: endpoint_local_references_non_prvgrp}, {resource: endpoint_url_references_non_prvgrp}])
      stub_request(:get, "#{url}/Endpoint?organization.type=prvgrp")
        .to_return(status: 200, body: bundle.to_json)

      result = run(forward_chain_test, url: url)
      expect(result.result).to eq('fail')
    end

    it 'Fails when collection of additional resources returns additional resource with incorrect value in desired field' do
      bundle.entry.concat([ {resource: endpoint_local_references_non_prvgrp }, {resource: endpoint_url_references_non_prvgrp}])
      stub_request(:get, "#{url}/Endpoint?organization.type=anomaly")
        .to_return(status: 200, body: bundle.to_json)

      stub_request(:get, "#{url}/Organization?type=anomaly")
        .to_return(status: 200, body: organization_bundle_with_multiple_types.to_json)

      result = run(forward_chain_test_non_prvgrp_type, url: url)
      expect(result.result).to eq('fail')
    end

    it 'Fails when server returns a non 200 status code and resulting message displays returned status code' do
      bundle.entry.concat([ {resource: endpoint_local }, {resource: endpoint_url }])
      stub_request(:get, "#{url}/Endpoint?organization.type=prvgrp")
        .to_return(status: 400, body: bundle.to_json)

      result = run(forward_chain_test, url: url)
      expect(result.result).to eq('fail')
      expect(result.result_message).to eq('Unexpected response status: expected 200, but received 400')
    end
    
    it 'Skips if server returns nothing' do
      stub_request(:get, "#{url}/Endpoint?organization.type=prvgrp")
        .to_return(status: 200, body: bundle.to_json)

      result = run(forward_chain_test, url: url)
      expect(result.result).to eq('skip')
    end

    # contextual call returning nothing is not tested.  I don't think this can happen (would be skipped once no
    # resource could be found to populate the field, basically the two cases below this comment)
    it 'Skips if scratch is empty' do
      result = run(forward_chain_test_no_scratch, url: url)
      expect(result.result).to eq('skip')
    end
    it 'Skips if scratch has no additional resources with desired field populated' do
      result = run(forward_chain_test_no_type, url: url)
      expect(result.result).to eq('skip')
    end
  end

  describe 'reverse chaining tests' do
    let(:reverse_chain_test) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::PractitionerReverseChainPractitionerRolePractitionerSpecialtySearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let(:reverse_chain_test_no_scratch) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::PractitionerReverseChainPractitionerRolePractitionerSpecialtySearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let(:reverse_chain_test_no_specialty) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::PractitionerReverseChainPractitionerRolePractitionerSpecialtySearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let (:practitioner_referenced_by_counselor) {
      FHIR::Practitioner.new(
        id: 'referenced-practitioner'
      )
    }
    let (:practitioner_unreferenced) {
      FHIR::Practitioner.new(
        id: 'unreferenced-practitioner'
      )
    }
    let (:practitioner_referenced_by_else) {
      FHIR::Practitioner.new(
        id: 'referenced-practitioner-else'
      )
    }
    let (:practitionerrole_with_reference_counselor) {
      FHIR::PractitionerRole.new(
        id: 'practitionerrole-with-reference-counselor',
        practitioner: {
          reference: 'Practitioner/referenced-practitioner'
        },
        specialty: [ {
          coding: [ {
            system: "http://nucc.org/provider-taxonomy",
            code: "COUNSELOR",
            display: "Professional Counselor"
          } ]
        } ]
      )
    }
    let (:practitionerrole_with_reference_else) {
      FHIR::PractitionerRole.new(
        id: 'practitionerrole-with-reference-else',
        practitioner: {
          reference: 'Practitioner/referenced-practitioner-else'
        },
        specialty: [ {
          coding: [ {
            system: "http://nucc.org/provider-taxonomy",
            code: "ELSE",
            display: "Professional Counselor"
          } ]
        } ]
      )
    }
    let (:practitionerrole_with_no_specialty) {
      FHIR::PractitionerRole.new(
        id: 'practitionerrole-no-specialty'
      )
    }
    let (:bundle) {
      FHIR::Bundle.new(
        entry: []
      )
    }
    let (:counselor_practitioner_bundle) {
      FHIR::Bundle.new(
        entry: [{resource: practitioner_referenced_by_counselor}]
      )
    }
    let (:counselor_practitionerrole_bundle) {
      FHIR::Bundle.new(
        entry: [{resource: practitionerrole_with_reference_counselor}]
      )
    }
    let (:mixed_specialty_practitioner_bundle) {
      FHIR::Bundle.new(
        entry: [{resource: practitioner_referenced_by_counselor}, {resource: practitioner_referenced_by_else}]
      )
    }
    let (:mixed_specialty_practitionerrole_bundle) {
      FHIR::Bundle.new(
        entry: [{resource: practitionerrole_with_reference_counselor}, {resource: practitionerrole_with_reference_else}]
      )
    }
    let (:bundle_with_unreferenced_practitioner){
      FHIR::Bundle.new(
        entry: [{resource: practitioner_referenced_by_counselor}, {resource: practitioner_unreferenced}]
      )
    }
    let (:test_scratch) { {
      all: [practitionerrole_with_reference_counselor]
    } }
    let (:empty_scratch) { {
      all: []
    } }
    let (:no_specialty_scratch) { {
      all: [practitionerrole_with_no_specialty]
    } }

    before do
      allow_any_instance_of(reverse_chain_test).to receive(:scratch_chain_resources).and_return(test_scratch)
      allow_any_instance_of(reverse_chain_test_no_scratch).to receive(:scratch_chain_resources).and_return(empty_scratch)
      allow_any_instance_of(reverse_chain_test_no_specialty).to receive(:scratch_chain_resources).and_return(no_specialty_scratch)
      stub_request(:get, "#{url}/PractitionerRole?specialty=COUNSELOR")
        .to_return(status: 200, body: counselor_practitionerrole_bundle.to_json)
    end

    it 'Passes when server returns all base resources that populate the desired field of an additional resource' do
      stub_request(:get, "#{url}/Practitioner?_has:PractitionerRole:practitioner:specialty=COUNSELOR")
        .to_return(status: 200, body: counselor_practitioner_bundle.to_json)
      
      result = run(reverse_chain_test, url: url)
      expect(result.result).to eq('pass')
    end

    it 'Passes when scratch is empty but user provides valid input' do
      stub_request(:get, "#{url}/Practitioner?_has:PractitionerRole:practitioner:specialty=COUNSELOR")
        .to_return(status: 200, body: counselor_practitioner_bundle.to_json)
      
      result = run(reverse_chain_test_no_scratch, url: url, practitioner_role_practitioner_specialty_input: 'COUNSELOR')
      expect(result.result).to eq('pass')
    end

    it 'Fails when server returns a base resource that is not referenced by relevant additional resources' do
      stub_request(:get, "#{url}/Practitioner?_has:PractitionerRole:practitioner:specialty=COUNSELOR")
        .to_return(status: 200, body: mixed_specialty_practitioner_bundle.to_json)
      
      result = run(reverse_chain_test, url: url)
      expect(result.result).to eq('fail')
    end

    it 'Fails when collection of additional resources returns additional resource with incorrect value in desired field' do
      stub_request(:get, "#{url}/Practitioner?_has:PractitionerRole:practitioner:specialty=COUNSELOR")
        .to_return(status: 200, body: counselor_practitioner_bundle.to_json)

      stub_request(:get, "#{url}/PractitionerRole?specialty=COUNSELOR")
        .to_return(status: 200, body: mixed_specialty_practitionerrole_bundle.to_json)

      result = run(reverse_chain_test, url: url)
      expect(result.result).to eq('fail')
    end

    it 'Fails when server returns a non 200 status code and resulting message displays returned status code' do
      stub_request(:get, "#{url}/Practitioner?_has:PractitionerRole:practitioner:specialty=COUNSELOR")
        .to_return(status: 400, body: counselor_practitioner_bundle.to_json)
      
      result = run(reverse_chain_test, url: url)
      expect(result.result).to eq('fail')
      expect(result.result_message).to eq('Unexpected response status: expected 200, but received 400')
    end

    it 'Skips if scratch is empty and not given input from user' do
      result = run(reverse_chain_test_no_scratch, url: url)
      expect(result.result).to eq('skip')
    end

    it 'Skips if scratch does not contain any resources that can be used and given no input from user' do
      result = run(reverse_chain_test_no_specialty, url: url)
      expect(result.result).to eq('skip')
    end
  end
end