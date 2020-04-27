class Person < ApplicationTable
  self.base_key = "appNpQYEz4XOan53g"
  self.table_name = "People"
  self.zendesk_id_field = "Zendesk ID"

  def self.import_all(people)
    ids_to_import = people.map { |h| h[:id].to_s }

    (ids_to_import - zendesk_ids).each do |id|
      import_from_zendesk(people, id)
    end
  end

  def self.import_from_zendesk(people, id)
    zendesk_person = people.find { |person| person[:id] == id.to_i }

    create(
      "#{zendesk_id_field}": zendesk_person[:id].to_s,
      "Name": zendesk_person[:name],
      "Email": zendesk_person[:email]
    )
  end
end
