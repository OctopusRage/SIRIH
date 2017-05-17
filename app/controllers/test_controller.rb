class TestController < ApplicationController
  before_action :authorize_user
  def index
    render json: {
      joke: 'hell no'
    }, status: 200 
  end
end
