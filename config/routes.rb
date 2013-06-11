class EffectivePagesRoutingConstraint
  def self.matches?(request)
    slug = request.path_parameters[:id] || '/'
    Effective::Page.where(:slug => slug).first.present?
  end
end

EffectivePages::Engine.routes.draw do

  scope :module => 'effective' do
    get '*id' => "pages#show", :constraints => EffectivePagesRoutingConstraint

    get '/edit(/*requested_uri)' => "mercury#edit", :as => :mercury_editor
    scope '/mercury' do
      get ':type/:resource' => "mercury#resource"
      get 'snippets/:name/options' => "mercury#snippet_options"
      get 'snippets/:name/preview' => "mercury#snippet_preview"
    end

  end
end
