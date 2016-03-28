module Blog
  module Routes
    class Index < Base
      include Brisk::Models

      get '/' do
        erb :index
      end

    end
  end
end
