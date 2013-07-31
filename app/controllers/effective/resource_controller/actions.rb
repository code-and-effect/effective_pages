module Effective::ResourceController::Actions

  def show(options = {}, &block)
    EffectivePages.authorized?(self, :read, resource)

    (raise ActiveRecord::RecordNotFound if (resource.draft? rescue false)) unless params[:mercury_frame]

    template = EffectivePages.templates[resource.template]
    template_info = EffectivePages.templates_info[resource.template]
    raise EffectivePages::TemplateNotFound.new(resource.template) unless template.kind_of?(HashWithIndifferentAccess)

    # Assign all content areas
    (template[:regions] || {}).each { |region, _| content_for(region, resource.regions[region]) }

    render "#{EffectivePages.templates_path.chomp('/')}/#{resource.template}", :layout => ((template_info[:layout].to_s rescue nil) || 'application')
  end
  alias :show! :show

  def edit(options = {}, &block)
    EffectivePages.authorized?(self, :update, resource)

    if params[:mercury_frame]
      show
    elsif resource.snippets.present?
      render(:file => 'effective/mercury/_load_snippets', :layout => 'effective_mercury')
    else
      render(:text => '', :layout => 'effective_mercury')
    end
  end

  def update(options = {}, &block)
    EffectivePages.authorized?(self, :update, resource)

    # Do the update.
    resource.regions = {} # Ensures there's no old regions or snippets kicking around. Only current valid ones.
    resource.snippets = {}

    params.require(:content).permit!().each do |region, vals| # Strong Parameters
      resource.regions[region] = cleanup(vals[:value])
      (vals[:snippets] || []).each { |snippet, vals| resource.snippets[snippet] = vals }
    end

    if resource.save
      render :text => '', :status => 200
    else
      render :text => '', :status => :unprocessable_entity
    end
  end

  def submit(options = {}, &block)
    object = resource
    EffectivePages.authorized?(self, :read, resource)

    if object.form.update_attributes(params[:effective_page_form])
      #options[:location] ||= smart_resource_url
    end

    respond_with_dual_blocks(object.form, options, &block)
  end
  alias :submit! :submit

  private

  # https://gist.github.com/hiroshi/985457
  def content_for(region, content)
    (@_content_for ||= {})[region] = content
  end

  def view_context
    super.tap do |view|
      (@_content_for || {}).each { |name, content| view.content_for name.to_sym, content.try(:html_safe) }
    end
  end

  def cleanup(str)
    if str
      # Remove the following markup
      #<div data-snippet="snippet_0" class="text_field_tag-snippet">[snippet_0/1]</div>
      # And replace with [snippet_0/1]
      # So we don't have a wrapping div in our final content
      str.scan(/(<div.+?>)(\[snippet_\d+\/\d+\])(<\/div>)/).each do |match|
        str.gsub!(match.join(), match[1]) if match.length == 3
      end

      str.gsub!("\n", '')
      str.chomp!('<br>') # Mercury editor likes to put in extra BRs
      str.strip!
      str
    end
  end


end
