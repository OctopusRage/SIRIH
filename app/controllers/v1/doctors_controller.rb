class V1::DoctorsController < ApplicationController
  before_action :authorize_user
  def index
    doctors = Doctor.all
    doctors = doctors.where("LOWER(name) LIKE ?", "%#{params[:name]}%") if params[:name].present?
    render json: {
      data: doctors
    }, status: 200
  end
end
