require "zendesk_api"
require "dotenv"
require "airrecord"

Dotenv.load
Airrecord.api_key = ENV["AIRTABLE_API_KEY"]

require_relative "./tables/application_table"
require_relative "./tables/project"
require_relative "./tables/person"

class ZendeskToAirtable
  PROJECT_FIELD_ID = 21915476
  GROUP_ID = 72939

  def run!
    import_projects
    import_users
  end

  def import_projects
    Project.import_all(projects)
  end

  def import_users
    Person.import_all(users_in_group)
  end

  private

  def projects
    @projects ||= begin
      client.ticket_fields.find(
        id: PROJECT_FIELD_ID
      )["custom_field_options"]
    end
  end

  def users_in_group
    @users ||= begin
      client.group_memberships
        .select { |g| g["group_id"] == GROUP_ID }
        .map { |g| all_users.find { |user| user["id"] == g["user_id"] } }
        .compact
        .uniq
    end
  end

  def all_users
    @all_users ||= begin
      users = []
      client.users.all { |u| users << u }
      users
    end
  end

  def client
    @client ||= begin
      ZendeskAPI::Client.new do |config|
        config.url = ENV["ZENDESK_API_URL"]
        config.username = ENV["ZENDESK_USERNAME"]
        config.token = ENV["ZENDESK_API_KEY"]
      end
    end
  end
end
