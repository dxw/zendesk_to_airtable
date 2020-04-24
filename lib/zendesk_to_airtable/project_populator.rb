require "zendesk_api"
require "dotenv"
require "airrecord"

Dotenv.load

require_relative "./project"

module ZendeskToAirtable
  class ProjectPopulator
    PROJECT_FIELD_ID = 21915476

    def import
      Project.import(projects)
    end

    private

    def projects
      @projects ||= begin
        client.ticket_fields.find(
          id: PROJECT_FIELD_ID
        )["custom_field_options"]
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
end
