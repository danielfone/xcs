class ContactsController < ApplicationController

  helper_method :external_link_to

  rescue_from Xero::Error, with: :render_xero_error

  def index
    @presenter = ContactIndexPresenter.new(view_context)
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
