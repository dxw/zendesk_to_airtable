module ZendeskToAirtable
  class Project < ApplicationTable
    self.base_key = "appNpQYEz4XOan53g"
    self.table_name = "Projects"
    self.zendesk_id_field = "Zendesk Project ID"

    def self.import_all(projects)
      project_ids_to_import = projects.map { |h| h[:id].to_s }

      (project_ids_to_import - zendesk_ids).each do |project_id|
        import_from_zendesk(projects, project_id)
      end
    end

    def self.import_from_zendesk(projects, project_id)
      zendesk_project = projects.find { |project| project[:id] == project_id.to_i }

      Project.create(
        "#{zendesk_id_field}": zendesk_project[:id].to_s,
        "Project Name": zendesk_project[:name]
      )
    end
  end
end
