require 'bundler'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/config_file'
Bundler.require

$LOAD_PATH << File.expand_path('../', __FILE__)
$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'app/models'
require 'app/routes'

module Blog
  class App < Sinatra::Application
    register Sinatra::ConfigFile

    configure do
      disable :method_override
      disable :static
      enable  :sessions
      config_file 'config/settings.yml'
    end

    def self.get_settings(env)
      settings.production
    end

    use Rack::Deflater
    use Blog::Routes::Base
    use Blog::Routes::Index
    use Blog::Routes::Posts
    use Blog::Routes::Authors
    use Blog::Routes::Tags
    use Blog::Routes::Comments
  end
end
