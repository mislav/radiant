module Admin::RegionsHelper
  def render_region(region, options={}, &block)
    lazy_initialize_region_set
    (options[:locals] ||= {}).update(:region_name => region.to_sym)
    default_partials = Radiant::AdminUI::RegionPartials.new(self)
    if block_given?
      block.call(default_partials)
      options[:locals][:defaults] = default_partials
    end
    @current_region_name = options[:locals][:region_name]
    @current_region_partials = default_partials
    
    output = @region_set[region].compact.map do |partial|
      begin
        render options.merge(:partial => partial)
      rescue ::ActionView::MissingTemplate # couldn't find template
        default_partials[partial]
      rescue ::ActionView::TemplateError => e # error in template
        raise e
      end
    end.join
    @current_region_name = @current_region_partials = nil
    block_given? ? concat(output) : output
  end
  
  # helper for extension partials to add to regions
  #
  # Example:
  #   - extend_region :thead do |thead|
  #     - include_stylesheet 'admin/extra_styles'
  #     - thead.custom_header do
  #       %th.custom Custom
  def extend_region(region, &block)
    if region.to_sym == @current_region_name
      block.call(@current_region_partials)
    end
  end

  def lazy_initialize_region_set
    unless @region_set
      @controller_name ||= @controller.controller_name
      @template_name ||= @controller.template_name
      @region_set = admin.send(@controller_name).send(@template_name)
    end
  end
end