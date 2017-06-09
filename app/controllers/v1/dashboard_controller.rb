class V1::DashboardController < ApplicationController
  before_action :authorize_user
  def index
    current_services_count = Registration.where(leave_status:false).count
    total_services = Registration.all.count
    new_patients_count = Registration.where(registration_date: Time.now).count    

    top10_dissease = Registration.where("diagnose is not null").group(:diagnose).order("count_all DESC").limit(10).count
    activities = Movement.joins(:registration, :bed => [:room]).order("entry_date DESC").limit(5)

    beds = Bed.joins(:movements, :room)
    room_usage = beds.group("rooms.name").order("count_all DESC").count
    total_room_usage = room_usage.map{|x|x[1]}.inject(0, :+)
    top_5_room = beds.group("rooms.name").order("count_all DESC").limit(5).count
    total_top_5_room = room_usage.map{|x|x[1]}.inject(0, :+)
    rest_total_room = total_room_usage - total_top_5_room
    room_usage_labels = []
    room_usage_values = []
    top_5_room.map {|e|
      room_usage_labels.push(e[0])
      room_usage_values.push((Float(e[1]) / total_room_usage * 100).round(2))
    }

    registrations_graph = Registration.group(:registration_date).order(:registration_date).count
    registration_graph_labels = []
    registration_graph_values = []
    registrations_graph.map{|r| 
      registration_graph_labels.push(r[0])
      registration_graph_values.push(r[1])
    }

    render json: {
      data: {
        stats: {
          total_services: total_services,
          current_services_count: current_services_count,
          new_patients_count: new_patients_count,
        },
        dissease: top10_dissease,
        activities: activities,
        graphs: {
          bed_percentage: {
            labels: room_usage_labels,
            values: room_usage_values
          },
          new_patient_chart: {
            labels: registration_graph_labels,
            values: registration_graph_values
          }
        }
      }
    }, status: 200
  end
end
