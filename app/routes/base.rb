module Blog
  module Routes
    class Base < Sinatra::Application

      include Blog::Models
      register Validator::Sinatra

      configure do
        set :views, 'app/views/'
        set :erb, layout: :'../layout'
        set :root, File.expand_path('../../../', __FILE__)
      end

      helpers do
        def errors
          @env['validator.messages']
        end
      end

      def self.current_dir
        'app/views/' + /^<class:([\w]*)>$/.match(caller_method)[1].downcase!.split('::').last
      end

      def self.caller_method(depth = 1)
        parse_caller(caller(depth + 1).first)
      end

      private

      def self.parse_caller(at)
        Regexp.last_match[3] if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
      end
    end
  end
end
