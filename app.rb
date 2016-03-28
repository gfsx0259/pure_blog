require 'bundler'
require 'sinatra'

Bundler.require

$LOAD_PATH << File.expand_path('../', __FILE__)
$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'app/models'
require 'app/routes'

module Blog
  class App < Sinatra::Application
    configure do
      disable :method_override
      disable :static
    end
    use Rack::Deflater
    use Blog::Routes::Base
    use Blog::Routes::Index
    use Blog::Routes::Posts
  end
end
