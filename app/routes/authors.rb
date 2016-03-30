module Blog
  module Routes
    class Authors < Base

     set :views, current_dir

      before { @author = Author.new }

      validation_required :POST, '/authors/add', params: Author::RULES
      validation_required :POST, '/authors/update/:id', params: Author::RULES

      get '/authors' do
        erb :index, locals: { authors: @author.get_list }
      end

      get '/authors/add' do
        erb :form
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
        erb :form, locals: { author: @author.get_by_id(params[:id]) }
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
        @author.delete(params[:id])
        redirect '/authors'
      end

      get '/authors/view/:id' do
        erb :view, locals: { author: @author.get_by_id(params[:id]) }
      end

    end
  end
end
