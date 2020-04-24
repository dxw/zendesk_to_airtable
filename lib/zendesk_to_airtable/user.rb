module ZendeskToAirtable
  class User < Airrecord::Table
    self.base_key = "appNpQYEz4XOan53g"
    self.table_name = "Users"

    def self.import(users)
      user_ids_to_import = users.map { |h| h[:id] }

      (user_ids_to_import - user_ids).each do |user_id|
        import_from_zendesk(users, user_id)
      end
    end

    def self.import_from_zendesk(users, user_id)
      zendesk_user = users.find { |user| user[:id] == user_id }

      create(
        "ID": zendesk_user[:id],
        "Name": zendesk_user[:name],
        "Email": zendesk_user[:email]
      )
    end

    def self.user_ids
      all.map { |p| p.fields["ID"] }
    end
  end
end
