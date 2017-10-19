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
