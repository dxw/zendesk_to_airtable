Airrecord.api_key = ENV["AIRTABLE_API_KEY"]

module ZendeskToAirtable
  class Project < Airrecord::Table
    self.base_key = "appNpQYEz4XOan53g"
    self.table_name = "Projects"

    def self.import(projects)
      project_ids_to_import = projects.map { |h| h[:id] }

      (project_ids_to_import - project_ids).each do |project_id|
        zendesk_project = projects.find { |project| project[:id] == project_id }

        Project.create(
          "ID": zendesk_project[:id],
          "Project Name": zendesk_project[:name]
        )
      end
    end

    def self.project_ids
      all.map { |p| p.fields["ID"] }
    end
  end
end
