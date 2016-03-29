module Blog
  module Routes
    class Base < Sinatra::Application
      configure do
        set :views, 'app/views/'
        set :erb, layout: :'../layout'
        set :root, File.expand_path('../../../', __FILE__)
      end

      def self.current_dir
        'app/views/' + /^<class:([\w]*)>$/.match(caller_method)[1].downcase!.split('::').last
      end

      def self.caller_method(depth = 1)
        parse_caller(caller(depth + 1).first)
      end

      private

      def self.parse_caller(at)
        if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
          Regexp.last_match[3]
        end
      end
    end
  end
end
