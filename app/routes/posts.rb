module Blog
  module Routes
    class Posts < Base
      include Blog::Models
      register Validator::Sinatra
      set :views, current_dir

      helpers do
        def errors
          @env['validator.messages']
        end
      end

      get '/posts' do
        erb :index, :locals => { posts: Db.new.get_list(:posts) }
      end

      get '/posts/add' do
        erb :add
      end

      validation_required :POST, '/posts/add', :params => Models::Posts::RULES

      post '/posts/add' do
        if errors
          session['errors'] = errors
          redirect '/posts/add'
        end
        Models::Posts.new.add(params)
        redirect '/posts'
      end
    end
  end
end
