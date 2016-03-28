rackup DefaultRackup
port ENV.fetch('PORT') { 9000 }
environment ENV.fetch('RACK_ENV') { 'development' }
preload_app!
