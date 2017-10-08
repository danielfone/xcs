class ContactsController < ApplicationController

  def index
    @contacts = Xero::Contact.all.order(:name)
  end

  def sync
    Xero::ContactPullJob.perform_now
    redirect_back fallback_location: :index
  end

end
