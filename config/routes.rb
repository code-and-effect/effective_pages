class EffectivePagesRoutingConstraint
  def self.matches?(request)
    Effective::Page.find(request.path_parameters[:id] || '/').present? rescue false
  end
end

EffectivePages::Engine.routes.draw do
  if defined?(EffectiveDatatables)
    namespace :admin do
      resources :pages, except: [:show]
      resources :menus, only: [:index, :show, :new, :create]
    end
  end

  scope :module => 'effective' do
    get '*id' => "pages#show", :constraints => EffectivePagesRoutingConstraint, :as => :page
  end
end

# Automatically mount the engine as an append
Rails.application.routes.append do
  unless Rails.application.routes.routes.find { |r| r.name == 'effective_pages' }
    mount EffectivePages::Engine => '/', :as => 'effective_pages'
  end
end

#root :to => 'Effective::Pages#show', :id => 'home'
