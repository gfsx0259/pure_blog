module Blog
  module Routes
    class Base < Sinatra::Application
      include Blog::Models
      register Validator::Sinatra

      configure do
        set :views, 'app/views/'
        set :root, File.expand_path('../../../', __FILE__)
      end

      helpers do
        def errors
          @env['validator.messages']
        end
      end

      def display(template, *args)
        erb File.join(current_dir, template.to_s).to_sym, *args
      end

      def current_dir
        caller_class.downcase!.split('::').last
      end

      private

      def caller_class
        /<class:([\w]*)>/.match(parse_caller(caller(2)[1]))[1]
      end

      def parse_caller(at)
        Regexp.last_match[3] if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
      end
    end
  end
end
