module Admin::ReferencesHelper
  def tag_reference
    returning String.new do |output|
      class_of_page.tag_descriptions.sort.each do |tag_name, description|
        output << render(:partial => "admin/references/tag_reference.haml", 
            :locals => {:tag_name => tag_name, :description => description})
      end
    end.html_safe
  end
  
  def filter_reference
    unless filter.blank?
      if filter.description.blank? 
        "There is no documentation on this filter." 
      else
        filter.description
      end
    else
      "There is no filter on the current page part."
    end
  end
  
  def _display_name
    case params[:type]
    when 'filters'
      filter ? filter.filter_name : '<none>'
    when 'tags'
      class_of_page.display_name
    end
  end
  
  def filter
    @filter ||= begin
      filter_name = params[:filter_name]
      (filter_name.gsub(" ", "") + "Filter").constantize unless filter_name.blank?
    end
  end
end
