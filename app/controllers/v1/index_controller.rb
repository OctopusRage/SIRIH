class V1::IndexController < ApplicationController
  before_action :authorize_user
  def index
    movements = Movement.joins(:registration).order("created_at DESC")
    payload = []
    movements.each do |m|
      payload = payload.merge({
        created_at: m.created_at.to_date,
        patient_id: m.registration.patient_id,
        patient_name: m.
      })