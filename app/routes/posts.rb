module Blog
  module Routes
    class Posts < Base
      include Blog::Models
      register Validator::Sinatra
      set :views, current_dir

      before do
        @post = Post.new
      end

      helpers do
        def errors
          @env['validator.messages']
        end
      end

      get '/posts' do
        erb :index, :locals => { posts: @post.get_list }
      end

      get '/posts/add' do
        erb :form
      end

      validation_required :POST, '/posts/add', :params => Post::RULES

      post '/posts/add' do
        if errors
          session['errors'] = errors
          redirect '/posts/add'
        end
        @post.add(params)
        redirect '/posts'
      end

      get '/posts/update/:id' do
        erb :form, :locals => { post: @post.get_by_id(params[:id])}
      end

      validation_required :POST, '/posts/update/:id', :params => Post::RULES

      post '/posts/update/:id' do
        if errors
          session['errors'] = errors
          redirect "/posts/update/#{params['id']}"
        end
        @post.update(params)
        redirect '/posts'
      end

      get '/posts/delete/:id' do
        @post.delete(params[:id])
        redirect '/posts'
      end

      get '/posts/view/:id' do
        erb :view, :locals => { post: @post.get_by_id(params[:id])}
      end

    end
  end
end
