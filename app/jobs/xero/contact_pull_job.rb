module Xero
  class ContactPullJob < ApplicationJob
    def perform
      Xero::Sync.new.perform
    end
  end
end
