module Xero
  class Contact < ApplicationRecord
    CONTACT_VIEW_PATH = "/Contacts/View.aspx?contactID=%<id>s"
    DEEP_LINK_URL = "https://go.xero.com/organisationlogin/default.aspx?" \
      "shortcode=%<shortcode>s&" \
      "redirecturl=%<target_url>s"

    class << self
      def active
        where status: 'ACTIVE'
      end

      def upsert_api_response(results, *args, &block)
        transaction do
          Array.wrap(results).each do |result|
            upsert_api_result(result, *args, &block)
          end
        end
      end

      def upsert_api_result(contact, org_code)
        # https://github.com/jesjos/active_record_upsert
        upsert(
          id: contact[:contact_id],
          name: contact[:name],
          status: (contact[:contact_status] || 'ACTIVE'),
          updated_at: contact[:updated_date_utc],
          synced_at: Time.current,
          data: contact.to_h,
          org_code: org_code
        )
      end

      def last_updated_at
        maximum(:updated_at)
      end

      def last_synced_at
        maximum(:synced_at)
      end
    end

    def muted?
      status == 'ARCHIVED'
    end

    def outstanding
      data.dig(
        'balances',
        'accounts_receivable',
        'outstanding'
      )
    end

    # https://developer.xero.com/documentation/api-guides/deep-link-xero
    def xero_url
      format(
        DEEP_LINK_URL,
        shortcode: org_code,
        target_url: format(CONTACT_VIEW_PATH, id: id)
      )
    end

  end
end
