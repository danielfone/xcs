class ContactIndexPresenter
  attr_reader :view_context
  alias_method :v, :view_context

  def initialize(view_context)
    @view_context = view_context
  end

  def contacts
    @contacts ||= Xero::Contact.all.order(:name)
  end

  def collection_info
    size = "Showing #{v.pluralize(contacts.size, "contacts")}"
    if contacts.any?
      "#{size}, last modified #{v.time_ago_in_words(contacts.last_updated_at)} ago."
    else
      "#{size}."
    end
  end

  def sync_info
    if contacts.any?
      "Last synced #{v.time_ago_in_words(contacts.last_synced_at)} ago."
    else
      "Never synced."
    end
  end

  def sync_button
    v.button_to("Sync Now", action: :sync)
  end

end
