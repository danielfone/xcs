module ApplicationHelper

  def external_link_to(name = nil, options = nil, html_options={})
    link_to options, html_options.merge(target: '_blank') do
      safe_join [name, " ", '☞']
    end
  end

end
