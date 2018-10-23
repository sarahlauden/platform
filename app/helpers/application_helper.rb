module ApplicationHelper
  def nav_link label, url, options={}
    options[:feather] ||= 'arrow-right-circle'
    
    text = "<span data-feather=\"#{options[:feather]}\"></span> #{label}".html_safe

    html_class = 'nav-link'
    
    if (options[:controller] ? (controller.controller_path == options[:controller]) : current_page?(url))
      html_class += ' active'
    end
    
    html_class += " #{controller.controller_path}"
    
    link_to(text, url, class: html_class)
  end
  
  def previous_page collection
    "#{request.base_url}#{request.path}?page=#{collection.previous_page}"
  end
  
  def next_page collection
    "#{request.base_url}#{request.path}?page=#{collection.next_page}"
  end
end
