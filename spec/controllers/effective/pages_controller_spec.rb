require 'spec_helper'

describe Effective::PagesController do
  routes { EffectivePages::Engine.routes }

  let(:page) { FactoryGirl.create(:page) }
  let(:draft) { FactoryGirl.create(:page, :draft => true) }
  let(:page_with_invalid_template) { FactoryGirl.create(:page, :template => 'notemplate') }
  let(:page_with_invalid_layout) { FactoryGirl.create(:page, :layout => 'nolayout') }

  before (:each) do
  end

  context "#show" do
    context 'valid requests' do
      it 'raises RecordNotFound when the page is a draft' do
        expect {
          get :show, :id => draft.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'renders a draft page when edit=true is passed' do
        get :show, :id => draft.id, :edit => true

        response.should be_success
      end

      it 'renders the appropriate page template' do
        get :show, :id => page.id

        expect(response).to render_template('layouts/application')
        expect(response).to render_template('effective/pages/example')
      end
    end

    context 'invalid requests' do
      it 'raises RecordNotFound when passed invalid ID' do
        expect { get :show, :id => 999 }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'raises MissingTemplate when the page has an unknown template' do
        expect {
          get :show, :id => page_with_invalid_template.id
        }.to raise_error(ActionView::MissingTemplate)
      end

      it 'raises MissingTemplate when the page has an unknown layout' do
        expect {
          get :show, :id => page_with_invalid_layout.id
        }.to raise_error(ActionView::MissingTemplate)
      end
    end

    context 'authentication' do
      it 'prevents the page from being viewed when not authorized' do
        original_auth_method = EffectivePages.authorization_method
        EffectivePages.authorization_method = Proc.new { |controller, action, resource| false }

        expect { get :show, :id => page.id }.to raise_error(Effective::AccessDenied)

        EffectivePages.authorization_method = original_auth_method
      end
    end
  end # /show

end
