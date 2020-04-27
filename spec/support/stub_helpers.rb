module StubHelpers
  def stub_zendesk_projects(projects)
    url = [
      ENV["ZENDESK_API_URL"],
      "ticket_fields",
      ZendeskToAirtable::PROJECT_FIELD_ID
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

  def stub_zendesk_group_memberships(memberships)
    url = [
      ENV["ZENDESK_API_URL"],
      "group_memberships"
    ].join("/")

    stub_request(:get, url)
      .to_return(
        status: 200,
        body: {
          "group_memberships": memberships
        }.to_json,
        headers: {
          "Content-Type": "application/json"
        }
      )
  end

  def stub_zendesk_users(users)
    url = [
      ENV["ZENDESK_API_URL"],
      "users"
    ].join("/")

    stub_request(:get, url)
      .to_return(
        status: 200,
        body: {
          "users": users
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
          "#{Project.zendesk_id_field}": project[:id].to_s,
          "Project Name": project[:name]
        },
        "createdTime": "2020-04-24T10:03:53.000Z"
      }
    }

    stub_request(:get, airtable_table_url(Project))
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

  def stub_airtable_users(users)
    records = users.map { |user|
      {
        "fields": {
          "#{Person.zendesk_id_field}": user[:id].to_s,
          "Name": user[:name],
          "Email": user[:email]
        },
        "createdTime": "2020-04-24T10:03:53.000Z"
      }
    }

    stub_request(:get, airtable_table_url(Person))
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

  def airtable_table_url(klass)
    [
      "https://api.airtable.com",
      "v0",
      klass.base_key,
      klass.table_name
    ].join("/")
  end
end

RSpec.configure do |config|
  config.include StubHelpers
end
