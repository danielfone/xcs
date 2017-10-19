module Xero
  class Upserter

    class << self
      def upsert_api_response(results, *args, &block)
        Contact.transaction do
          Array.wrap(results).each do |result|
            upsert_api_result(result, *args, &block)
          end
        end
      end

      def upsert_api_result(contact, org_code)
        # https://github.com/jesjos/active_record_upsert
        Contact.upsert(
          id: contact[:contact_id],
          name: contact[:name],
          status: (contact[:contact_status] || 'ACTIVE'),
          updated_at: contact[:updated_date_utc],
          synced_at: Time.current,
          data: contact.to_h,
          org_code: org_code
        )
      end
    end
  end
end
