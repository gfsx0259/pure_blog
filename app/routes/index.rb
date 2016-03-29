module Blog
  module Routes
    class Index < Base
      include Blog::Models
      set :views, current_dir

      get '/' do
        erb :index
      end
    end
  end
end
