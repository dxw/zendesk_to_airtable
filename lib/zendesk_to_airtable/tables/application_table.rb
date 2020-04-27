module ZendeskToAirtable
  class ApplicationTable < Airrecord::Table
    class << self
      attr_accessor :zendesk_id_field

      def zendesk_ids
        all.map { |p| p.fields[zendesk_id_field] }
      end
    end
  end
end
