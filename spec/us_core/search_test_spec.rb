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
    let(:test_scratch) { {
      all: [endpoint_local, endpoint_url]
    } }
    let(:only_url_scratch) { {
      all: [endpoint_url]
    } }
    let(:empty_scratch) { {
      all: []
    }}
    let(:no_reference_scratch){ {
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
    let(:test_scratch) { {
      all: [endpoint_local, endpoint_url]
    } }
    let(:only_url_scratch) { {
      all: [endpoint_url]
    } }
    let(:empty_scratch) { {
      all: []
    }}
    let(:no_reference_scratch){ {
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

    it 'skips when no additional resources are returned' do
      stub_request(:get, "#{url}/Organization?_id=Organization/#{organization_local.id}&_revinclude=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(revinclude_test, url: url)
      expect(result.result).to eq('skip')
    end

    it 'skips when scratch is empty' do
      result = run(revinclude_test_no_scratch, url: url)
      expect(result.result).to eq('skip')
    end

    it 'skips when scratch does not contain base resources that have desired reference' do
      result = run(revinclude_test_no_reference, url: url)
      expect(result.result).to eq('skip')
    end
  end
end