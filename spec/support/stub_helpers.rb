module StubHelpers
  def stub_zendesk_projects(projects)
    url = [
      ENV["ZENDESK_API_URL"],
      "ticket_fields",
      ZendeskToAirtable::ProjectPopulator::PROJECT_FIELD_ID
    ].join("/")

    stub_request(:get, url)
      .to_return(
        status: 200,
        body: {
          "ticket_field": {
            "custom_field_options": projects
          }
        }.to_json,
        headers: {
          "Content-Type": "application/json"
        }
      )
  end

  def stub_airtable_projects(projects)
    records = projects.map { |project|
      {
        "fields": {
          "ID": project[:id],
          "Project Name": project[:name]
        },
        "createdTime": "2020-04-24T10:03:53.000Z"
      }
    }

    stub_request(:get, airtable_table_url)
      .to_return(
        status: 200,
        body: {
          "records": records
        }.to_json,
        headers: {
          "Content-Type": "application/json"
        }
      )
  end

  def airtable_table_url
    [
      "https://api.airtable.com",
      "v0",
      ZendeskToAirtable::Project.base_key,
      ZendeskToAirtable::Project.table_name
    ].join("/")
  end
end

RSpec.configure do |config|
  config.include StubHelpers
end
