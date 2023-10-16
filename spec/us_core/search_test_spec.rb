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
    let (:test_class) do 
      Class.new(DaVinciPDEXPlanNetTestKit::DaVinciPDEXPlanNetV110::EndpointIncludeEndpointOrganizationSearchTest) do
        fhir_client {url :url}
        input :url
      end
    end
    let(:test_scratch) { {} }
    let (:endpoint_1) {
      FHIR::Endpoint.new(
        id: 'endpoint-local-reference',
        managingOrganizaton: {
          reference: "Organization/acme"
        }
      )
    }
    let (:endpoint_2) {
      FHIR::Endpoint.new(
        id: 'endpoint-url',
        managingOrganizaton: {
          reference: "http://example.com/Organization/ecorp"
        }
      )
    }
    let (:organization_1) {
      FHIR::Organization.new(
        id: 'acme'
      )
    }
    let (:organization_2) {
      FHIR::Organization.new(
        id: 'ecorp'
      )
    }
    let (:organization_3) {
      FHIR::Organization.new(
        id: 'org-3'
      )
    }
    let (:bundle ) {
      FHIR::Bundle.new(
        entry: [
          { resource: endpoint_1 },
          { resource: endpoint_2 }
        ]
      )
    }

    before do
      allow_any_instance_of(test_class).to receive(:scratch).and_return(test_scratch)
      stub_request(:get, "#{url}/Endpoint")
        .to_return(status: 200, body: FHIR::Bundle.new.to_json)
    end

    it 'passes when references and included Resources are exact match' do
      bundle.entry.concat([ {resource: organization_1 }, {resource: organization_2}])
      stub_request(:get, "#{url}/Endpoint?_include=Endpoint:organization")
        .to_return(status: 200, body: bundle.to_json)

      result = run(test_class, url: url)
      expect(result.result).to eq('pass')
    end
  end
end
