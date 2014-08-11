require 'sinatra/base'

class Vaab < Sinatra::Base
  set :static, true
  set :public, File.dirname(__FILE__) + '/static'

  get '/' do
    erb :index
  end

  get '/murals' do
   erb :murals
  end

  get '/gifs' do
    erb :gifs
  end
end


