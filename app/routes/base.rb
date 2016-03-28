module Blog
  module Routes
    class Base < Sinatra::Application
      configure do
        set :views, 'app/views/'
        set :erb, layout: :'../layout'
        set :root, File.expand_path('../../../', __FILE__)
        set :show_exceptions, :after_handler
      end

      def self.current_dir
        'app/views/' + /^<class:([\w]*)>$/.match(caller_method)[1].downcase!.split('::').last
      end

      def self.caller_method(depth = 1)
        parse_caller(caller(depth + 1).first).last
      end

      private

      def self.parse_caller(at)
        if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
          file   = Regexp.last_match[1]
          line   = Regexp.last_match[2].to_i
          method = Regexp.last_match[3]
          [file, line, method]
        end
      end
    end
  end
end
