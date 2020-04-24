require "spec_helper"

RSpec.describe ZendeskToAirtable::ProjectPopulator do
  describe "#import_projects" do
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
        stub_request(:post, airtable_table_url(ZendeskToAirtable::Project))
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
        described_class.new.import_projects

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
        stub_request(:post, airtable_table_url(ZendeskToAirtable::Project))
          .to_return(status: 201, body: {}.to_json, headers: {})
      end

      it "does not import any projects" do
        described_class.new.import_projects

        expect(project_creation_stub).to_not have_been_requested
      end
    end
  end

  describe "#import_users" do
    let(:zendesk_group_memberships) do
      [
        {
          "user_id": 4567,
          "group_id": ZendeskToAirtable::ProjectPopulator::GROUP_ID
        },
        {
          "user_id": 1234,
          "group_id": ZendeskToAirtable::ProjectPopulator::GROUP_ID
        },
        {
          "user_id": 10793415,
          "group_id": 1234
        }
      ]
    end

    let(:zendesk_users) do
      [
        {
          id: 1234,
          name: "Foo",
          email: "foo@example.com"
        },
        {
          id: 4567,
          name: "Bar",
          email: "bar@example.com"
        }
      ]
    end

    before do
      stub_zendesk_group_memberships(zendesk_group_memberships)
      stub_zendesk_users(zendesk_users)
      stub_airtable_users(airtable_users)
    end

    context "when there are new users to be added" do
      let(:airtable_users) do
        [
          {
            id: 1234,
            name: "Foo",
            email: "foo@example.com"
          }
        ]
      end

      let!(:project_creation_stub) do
        stub_request(:post, airtable_table_url(ZendeskToAirtable::User))
          .with(
            body: {
              "fields": {
                "ID": 4567,
                "Name": "Bar",
                "Email": "bar@example.com"
              }
            }.to_json
          )
          .to_return(status: 201, body: {}.to_json, headers: {})
      end

      it "imports users" do
        described_class.new.import_users

        expect(project_creation_stub).to have_been_requested
      end
    end

    context "when there are no users to be added" do
      let(:airtable_users) do
        [
          {
            id: 1234,
            name: "Foo",
            email: "foo@example.com"
          },
          {
            id: 4567,
            name: "Bar",
            email: "bar@example.com"
          }
        ]
      end

      let!(:project_creation_stub) do
        stub_request(:post, airtable_table_url(ZendeskToAirtable::User))
          .to_return(status: 201, body: {}.to_json, headers: {})
      end

      it "does not import any users" do
        described_class.new.import_users

        expect(project_creation_stub).to_not have_been_requested
      end
    end
  end
end
