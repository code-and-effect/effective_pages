# frozen_string_literal: true

EffectivePages::Engine.routes.draw do
  namespace :admin do
    resources :pages, except: [:show]
    resources :page_sections, only: [:index, :edit, :update]
    resources :menus, only: [:index]
  end

  scope module: 'effective' do
    match '*id', to: 'pages#show', via: :get, as: :page, constraints: lambda { |req|
      Effective::Page.find_by_slug_or_id(req.path_parameters[:id] || '/').present?
    }
  end
end

# Automatically mount the engine as an append
Rails.application.routes.append do
  unless Rails.application.routes.routes.find { |r| r.name == 'effective_pages' }
    mount EffectivePages::Engine => '/', as: 'effective_pages'
  end
end

#root to: 'effective/pages#show', id: 'home'
