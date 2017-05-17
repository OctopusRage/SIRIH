class V1::AuthController < ApplicationController
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      render json: {
        data: user
      }, status: 200
    else
      render json:{
        status: 'fail',
        message: 'wrong username or password'
      }, status: 400
    end
  end
end
