class V1::UsersController < ApplicationController
  before_action :authorize_user
  def index
    if current_user.role != 1 
      render json: {
        status: 'fail',
        data: {
          message: 'unauthorized access'
        }
      }, status: 503 and return
    end
    users = User.all.page(params[:page]).per(params[:limit])
    render json: {
      data: users,
      total: users.total_count
    }, status: 200
  end
  
  def create
    if current_user.role != 1 
      render json: {
        status: 'fail',
        errors: {
          message: 'unauthorized access'
        }
      }, status: 503 and return
    end
    user = User.find_by(username: params[:username])
    if params[:password] != params[:password_confirmation]
      render json: {
        errors: {
          message: 'Paswword does not match'
        }
      }, status: 422 and return
    end
    if user.present? || params[:password] != params[:password_confirmation]
      render json: {
        errros: {
          message: 'User already exist'
        }
      }, status: 422 and return
    end
    user = User.create(username: params[:username], name: params[:name], password: params[:password], role: 2)
    if !user.valid? 
      render json: {
        errors: {
          message: user.errors.first.join(" ")
        }
      }, status: 422 and return
    end
    render json: {
      data: user
    }, status: 201
  end

  def show 
    if current_user.role != 1 
      render json: {
        status: 'fail',
        data: {
          message: 'unauthorized access'
        }
      }, status: 503 and return
    end
    user = User.find(params[:id])
    render json: {
      data: user
    }, status: 200
  end
  
  def update
    if current_user.role != 1 
      render json: {
        status: 'fail',
        data: {
          message: 'unauthorized access'
        }
      }, status: 503 and return
    end
    user = User.find(user_params[:id])
    if user.nil?
      render json: {
        errors: {
          message: 'not found'
        }
      }, status: 404 and return
    end
    if user_params[:password].present? && user_params[:password] != user_params[:password_confirmation]
      render json: {
        errors: {
          message: 'password doesnt match'
        }
      }, status: 422 and return
    end
      
    user.update(user_params)      
    render json: {
      data: {
        user: user
      }
    }, status: 200 and return
  end

  def destroy
    if current_user.role != 1 
      render json: {
        status: 'fail',
        errors: {
          message: 'unauthorized access'
        }
      }, status: 503 and return
    end
    user = User.find(params[:id])
    if user
      user.delete
      render json: {
        message: 'user has been deleted'
      }, status: 200 and return
    else
      render json: {
        status: 'fail',
        errors: {
          message: 'failed to delete message'
        }
      }, status:422
    end  
  end
  
  private
    def user_params
      params.permit(:id, :username, :password, :name, :password_confirmation, :role)
    end
end
