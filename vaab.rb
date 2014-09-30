require 'sinatra/base'

class Vaab < Sinatra::Base
  set :static, true
  set :public, File.dirname(__FILE__) + '/static'

  get '/' do
    erb :index, :locals => {:menu_item => "home"}
  end

  get '/murals' do
   erb :murals, :locals => {:menu_item => "murals"}
  end

  get '/engines' do
    erb :engines, :locals => {:menu_item => "engines"}
  end

  get '/about' do
    erb :about, :locals => {:menu_item => "about"}
  end

  get '/engine_00000' do
    erb :engines_three, :layout => false
  end

  get '/mural_00000' do
    erb :mural_00000
  end

  get '/mural_00001' do
    erb :mural_00001
  end

  get '/next_mural' do
    erb :next_mural
  end
  
end


