# Rails.application.routes.draw do
#   scope :module => 'effective' do
#     resources :pages
#   end

#   #match '*id' => "pages#show"
# end


EffectivePages::Engine.routes.draw do
  scope :module => 'effective' do
    resources :pages
  end
end
