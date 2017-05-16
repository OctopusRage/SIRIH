class TestController < ApplicationController
  http_basic_authenticate_with :name => "user", :password => "password" 
  def index
    render json: {
      joke: 'hell no'
    }, status: 200 
  end
end
