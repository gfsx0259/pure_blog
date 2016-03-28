module Blog
  module Routes
    class Base < Sinatra::Application
      configure do
        set :views, 'app/views/'
        set :root, File.expand_path('../../../', __FILE__)
        set :show_exceptions, :after_handler
      end
    end
  end
end
