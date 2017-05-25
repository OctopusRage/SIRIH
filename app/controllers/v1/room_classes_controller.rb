class V1::RoomClassesController < ApplicationController
  before_action :authorize_user
  def index
    room_classes = RoomClass.all
    room_classes = room_classes.where("LOWER(name) LIKE ?", "%#{params[:name]}%") if params[:name].present?
    render json: {
      data: room_classes
    }, status: 200
  end
  
  def show
    room_class = RoomClass.find(params[:id])
    render json:{
      data: room_class
    }
  end
  
end
