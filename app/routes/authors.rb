module Blog
  module Routes
    class Authors < Base
      before { @author = Author.new }

      validation_required :POST, '/authors/add', params: Author::RULES
      validation_required :POST, '/authors/update/:id', params: Author::RULES

      get '/authors' do
        display :index, locals: { authors: @author.get_list }
      end

      get '/authors/add' do
        display :form
      end

      post '/authors/add' do
        if errors
          session['errors'] = errors
          redirect '/authors/add'
        end

        @author.add(params)
        redirect '/authors'
      end

      get '/authors/update/:id' do
        display :form, locals: { author: @author.get_by_id(params[:id]) }
      end

      post '/authors/update/:id' do
        if errors
          session['errors'] = errors
          redirect "/authors/update/#{params['id']}"
        end
        @author.update(params)
        redirect '/authors'
      end

      get '/authors/delete/:id' do
        Comment.new.delete_by_author(params[:id])
        @author.delete(params[:id])
        redirect '/authors'
      end

      get '/authors/view/:id' do
        display :view, locals: { author: @author.get_by_id(params[:id]) }
      end
    end
  end
end
