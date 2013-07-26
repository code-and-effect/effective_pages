require 'spec_helper'

describe Effective::PagesController do
  let(:page) { FactoryGirl.create(:page) }
  let(:draft) { FactoryGirl.create(:page, :draft => true) }
  let(:page_with_invalid_template) { FactoryGirl.create(:page, :template => 'notemplate') }

  before (:each) do
  end

  context "#show" do
    context 'valid requests' do
      it 'raises RecordNotFound when the page is a draft' do
        expect {
          get :show, :id => draft.id, :use_route => :effective_pages
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'renders a draft page when inside the mercury_editor frame' do
        get :show, :id => draft.id, :mercury_frame => true, :use_route => :effective_pages

        response.should be_success
      end

      it 'renders the appropriate page template' do
        get :show, :id => page.id, :use_route => :effective_pages

        expect(response).to render_template('layouts/application')
        expect(response).to render_template('templates/template1')
      end

      it 'assigns content areas as per the regions' do
        ActionView::Base.any_instance.should_receive(:content_for).with(:title, page.regions[:title])
        ActionView::Base.any_instance.should_receive(:content_for).with(:content, page.regions[:content])

        get :show, :id => page.id, :use_route => :effective_pages
      end
    end

    context 'invalid requests' do
      it 'raises RecordNotFound when passed invalid ID' do
        expect { get :show, :id => 999, :use_route => :effective_pages }.to raise_error(ActiveRecord::RecordNotFound)
        expect { get :show, :id => nil, :use_route => :effective_pages }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'raises TemplateNotFound when the page has an unknown template' do
        expect {
          get :show, :id => page_with_invalid_template.id, :use_route => :effective_pages
        }.to raise_error(EffectivePages::TemplateNotFound)
      end
    end

    context 'authentication' do
      it 'prevents the page from being viewed when not authorized' do
        original_auth_method = EffectivePages.authorization_method
        EffectivePages.authorization_method = Proc.new { |controller, action, resource| false }

        expect {
          get :show, :id => page.id, :use_route => :effective_pages
        }.to raise_error(ActiveResource::UnauthorizedAccess)

        EffectivePages.authorization_method = original_auth_method
      end
    end
  end # /show

  context "#edit" do
    it 'should render the effective_mercury editor when called with no parameters' do
      page.snippets = {}
      page.save

      get :edit, :id => page.id, :use_route => :effective_pages

      expect(response).to render_template('layouts/effective_mercury')
      expect(response).not_to render_template('layouts/application')
      expect(response).not_to render_template('effective/mercury/_load_snippets')
    end

    it 'should render the load_snippets partial if page has snippets' do
      get :edit, :id => page.id, :use_route => :effective_pages

      expect(response).to render_template('effective/mercury/_load_snippets')
    end

    it 'should render the show action when called within the effective_mercury frame' do
      get :edit, :id => page.id, :mercury_frame => true, :use_route => :effective_pages

      expect(response).to render_template('templates/template1')
      expect(response).not_to render_template('layouts/effective_mercury')
    end
  end # /edit

  context '#update' do
    it 'updates the page region as appropriate' do
      params = {'content'=>{'title'=>{'type'=>'simple', 'data'=>{}, 'value'=>'Identifying Your Feelings<br>'}}}

      put :update, {:id => page.id, :use_route => :effective_pages}.merge(params)

      page.reload
      page.regions['title'].should eq 'Identifying Your Feelings' # Stripped of tailing <br>
    end

    it 'updates the page snippets as appropriate' do
      params = {"content"=>{"content"=>{"type"=>"full", "data"=>{}, "value"=>"Checklist<div data-snippet=\"snippet_0\" class=\"text_field_tag-snippet\">[snippet_0/1]</div><br>", "snippets"=>{"snippet_0"=>{"name"=>"text_field_tag", "options"=>{"name"=>"favorite_beer", "required"=>"on", "maxlength"=>"", "placeholder"=>"", "html_class"=>"span4"}}}}}}

      put :update, {:id => page.id, :use_route => :effective_pages}.merge(params)

      page.reload
      page.snippets['snippet_0'][:name].should eq 'text_field_tag'
      page.snippets['snippet_0'][:options][:name].should eq 'favorite_beer'
      page.snippets['snippet_0'][:options][:required].should eq 'on'
      page.snippets['snippet_0'][:options][:html_class].should eq 'span4'
    end

    it 'strips out the <div data-snippet= ..> from regions' do
      params = {"content"=>{"content"=>{"type"=>"full", "data"=>{}, "value"=>"Checklist<div data-snippet=\"snippet_0\" class=\"text_field_tag-snippet\">[snippet_0/1]</div><br>"}}}

      put :update, {:id => page.id, :use_route => :effective_pages}.merge(params)

      page.reload
      page.regions['content'].should eq 'Checklist[snippet_0/1]'
    end
  end # /update

end
