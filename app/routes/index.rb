module Blog
  module Routes
    class Index < Base
      include Blog::Models

      get '/' do
        display :index
      end
    end
  end
end
