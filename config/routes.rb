class EffectivePagesRoutingConstraint
  def self.matches?(request)
    slug = request.path_parameters[:id] || '/'
    Effective::Page.where(:slug => slug).first.present?
  end
end

EffectivePages::Engine.routes.draw do
  scope :module => 'effective' do
    get '*id' => "pages#show", :constraints => EffectivePagesRoutingConstraint
  end
end
