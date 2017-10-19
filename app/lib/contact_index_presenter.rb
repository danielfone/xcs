class ContactIndexPresenter
  attr_reader :view_context
  alias_method :v, :view_context

  def initialize(view_context)
    @view_context = view_context
  end

  def contacts
    @contacts ||= contact_scope.map { |c| ContactDecorator.new(c, view: v) }
  end

  def collection_info
    size = "Showing #{v.pluralize(contact_scope.size, "contacts")}"
    if contact_scope.any?
      "#{size}, last modified #{v.time_ago_in_words(contact_scope.last_updated_at)} ago."
    else
      "#{size}."
    end
  end

  def sync_info
    if contact_scope.any?
      "Last synced #{v.time_ago_in_words(contact_scope.last_synced_at)} ago."
    else
      "Never synced."
    end
  end

  def sync_button
    v.button_to("Sync Now", action: :sync)
  end

  def each_contact_row(&block)
    contacts.each do |contact|
      dom_class = 'struck-out-element' if contact.archived?
      v.content_tag(:tr, v.capture(contact, &block), class: dom_class)
    end
  end

private

  def contact_scope
    @contact_scope ||= Xero::Contact.all.order(:name)
  end

end
