# required gem includes
require 'sinatra'
require "sinatra/json"
require 'rack-flash'
require_relative 'lib/rentSplitter.rb'


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
  if session['rent_session']
    @user = ShowMeMoney.dbi.get_user_by_id(session['rent_session'])
    redirect to '/main'
  end
  erb :index
end

# get '/signup' do
#   if session['rent_session']
#     redirect to '/'
#   else
#     erb :signup
#   end
# end

post '/signin' do
  sign_in = RPS::SignIn.run(params)
  if sign_in[:success?]
    session['rent_session'] = sign_in[:session_id]
    redirect to '/main'
  else
    flash[:alert] = sign_in[:error]
    erb :index
  end
end

post '/signup' do
  sign_up = RPS::SignUp.run(params)
  if sign_up[:success?]
    session['rent_session'] = sign_up[:session_id]
    redirect to '/main'
  else
    flash[:alert] = sign_up[:error]
    erb :index
  end 

end

get '/main' do
  #get all expenses for domicile for current month and year selected
  #get domicile info for current month and year selected

end




get '/signout' do
  session.clear
  redirect to '/'
end


post 'tab' do
  redirect to '/'

end
