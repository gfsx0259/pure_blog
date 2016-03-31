module Blog
  module Routes
    class Tags < Base
      before { @tag = Tag.new }

      validation_required :POST, '/tags/add', params: Tag::RULES
      validation_required :POST, '/tags/update/:id', params: Tag::RULES

      get '/tags' do
        display :index, locals: { tags: @tag.get_list }
      end

      get '/tags/add' do
        display :form
      end

      post '/tags/add' do
        if errors
          session['errors'] = errors
          redirect '/tags/add'
        end
        @tag.add(params)
        redirect '/tags'
      end

      get '/tags/update/:id' do
        display :form, locals: { tag: @tag.get_by_id(params[:id]) }
      end

      post '/tags/update/:id' do
        if errors
          session['errors'] = errors
          redirect "/tags/update/#{params['id']}"
        end
        @tag.update(params)
        redirect '/tags'
      end

      get '/tags/delete/:id' do
        @tag.delete(params[:id])
        redirect '/tags'
      end

      get '/tags/view/:id' do
        display :view, locals: { tag: @tag.get_by_id(params[:id]) }
      end
    end
  end
end
