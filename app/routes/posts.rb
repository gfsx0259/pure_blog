module Blog
  module Routes
    class Posts < Base
      include Blog::Models
      set :views, current_dir
      get '/posts' do
        erb :index
      end
    end
  end
end
