class EffectivePagesRoutingConstraint
  def self.matches?(request)
    id = request.path_parameters[:id] || '/'
    Effective::Page.find(id).present? rescue false
  end
end

EffectivePages::Engine.routes.draw do
  if defined?(EffectiveDatatables)
    namespace :admin do
      resources :pages, :except => [:show]
    end
  end

  scope :module => 'effective' do
    get '*id' => "pages#show", :constraints => EffectivePagesRoutingConstraint, :as => :page
  end
end

# Automatically mount the engine as an append
Rails.application.routes.append do
  mount EffectivePages::Engine => '/', :as => 'effective_pages'
end

#root :to => 'Effective::Pages#show', :id => 'home'
