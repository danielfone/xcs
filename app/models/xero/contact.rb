module Xero
  class Contact < ApplicationRecord

    scope :active, -> { where status: 'ACTIVE' }

    def self.upsert_api_response(results, *args, &block)
      transaction do
        Array.wrap(results).each do |result|
          upsert_api_result(result, *args, &block)
        end
      end
    end

    def self.upsert_api_result(contact)
      # https://github.com/jesjos/active_record_upsert
      upsert(
        id: contact[:contact_id],
        name: contact[:name],
        status: (contact[:contact_status] || 'ACTIVE'),
        updated_at: contact[:updated_date_utc],
        synced_at: Time.current,
        data: contact.to_h,
      )
    end

    def self.last_updated_at
      maximum(:updated_at)
    end

    def self.last_synced_at
      maximum(:synced_at)
    end

    def archived?
      status == 'ARCHIVED'
    end

  end
end
