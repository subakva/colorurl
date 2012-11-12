require File.join(File.dirname(__FILE__), 'colorurl.rb')

disable :run
set :environment, :production
run Sinatra::Application
