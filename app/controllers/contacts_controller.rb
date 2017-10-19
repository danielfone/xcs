class ContactsController < ApplicationController

  rescue_from Xero::Error, with: :render_xero_error

  def index
    @contacts = Xero::Contact.all.order(:name)
  end

  def sync
    Xero::ContactPullJob.perform_now
    flash[:success] = "Updated contacts from Xero"
    redirect_back fallback_location: :index
  end

private

  def render_xero_error(error)
    flash[:error] = "[Xero Error] #{error.message}"
    redirect_back fallback_location: :root
  end

end
