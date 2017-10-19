module Xero
  class ContactPullJob < ApplicationJob
    def perform
      Xero::Sync.new(api_client).perform
    end

    def api_client
      Xero::Client.new.api_client
    end
  end
end
