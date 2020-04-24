require "spec_helper"

RSpec.describe ZendeskToAirtable::ProjectPopulator do
  before do
    stub_zendesk_projects(zendesk_projects)
    stub_airtable_projects(airtable_projects)
  end

  context "when there are new projects to be added" do
    let(:zendesk_projects) do
      [
        {
          "id": 24799349,
          "name": "bis: BIS WordPress sites"
        },
        {
          "id": 24799369,
          "name": "business-bank: Business Bank"
        }
      ]
    end

    let(:airtable_projects) do
      [
        {
          "id": 24799349,
          "name": "bis: BIS WordPress sites"
        }
      ]
    end

    let!(:project_creation_stub) do
      stub_request(:post, airtable_table_url)
        .with(
          body: {
            "fields": {
              "ID": 24799369,
              "Project Name": "business-bank: Business Bank"
            }
          }.to_json
        )
        .to_return(status: 201, body: {}.to_json, headers: {})
    end

    it "only imports projects that don't exist" do
      described_class.new.import

      expect(project_creation_stub).to have_been_requested
    end
  end

  context "when there are no projects to import" do
    let(:zendesk_projects) do
      [
        {
          "id": 24799349,
          "name": "bis: BIS WordPress sites"
        },
        {
          "id": 24799369,
          "name": "business-bank: Business Bank"
        }
      ]
    end

    let(:airtable_projects) do
      [
        {
          "id": 24799349,
          "name": "bis: BIS WordPress sites"
        },
        {
          "id": 24799369,
          "name": "business-bank: Business Bank"
        }
      ]
    end

    let!(:project_creation_stub) do
      stub_request(:post, airtable_table_url)
        .to_return(status: 201, body: {}.to_json, headers: {})
    end

    it "does not import any projects" do
      described_class.new.import

      expect(project_creation_stub).to_not have_been_requested
    end
  end
end
