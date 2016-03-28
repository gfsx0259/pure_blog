module Blog
  module Routes
    class Index < Base
      set :views, current_dir

      include Blog::Models
      get '/' do
        erb :index
      end
    end
  end
end
