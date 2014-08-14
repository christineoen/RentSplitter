# required gem includes
require 'sinatra'
require "sinatra/json"
require 'rack-flash'
require_relative 'lib/rps_app.rb'


set :bind, '0.0.0.0' # Vagrant fix
set :port, '4567'
set :sessions, true
set :session_secret, 'super secret'
use Rack::Flash

# partial
# layouts

before do
  @root = 'http://10.10.10.10:4567/'
end

get '/' do
  @home = 'js/home.js'
  if session['sesh_example']
    @user = RPS.dbi.get_player_by_username(session['sesh_example'])
    redirect to '/matches'
  end
  erb :index
end

get '/signup' do
  @home = 'js/home.js'
  if session['sesh_example']
    redirect to '/'
  else
    erb :signup
  end
end

post '/signin' do
  sign_in = RPS::SignIn.run(params)
  if sign_in[:success?]
    session['sesh_example'] = sign_in[:session_id]
    redirect to '/matches'
  else
    @home = 'js/home.js'
    flash[:alert] = sign_in[:error]
    erb :index
  end
end

post '/signup' do
  sign_up = RPS::SignUp.run(params)
  if sign_up[:success?]
    session['sesh_example'] = sign_up[:session_id]
    redirect to '/matches'
  else
    @home = 'js/home.js'
    flash[:alert] = sign_up[:error]
    erb :index
  end 

end

get '/signout' do
  session.clear
  redirect to '/'
end


post 'tab' do
  redirect to '/'

end
