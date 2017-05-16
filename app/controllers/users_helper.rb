module UsersHelper
  def authorize_user
    render json: {
      status: 'fail',
      message: 'Unauthorized Access',
      data: {
        message: 'Unauthorized Access'
      }
    }, status: 403 unless current_user
  end

  def current_user
    @current_user ||= token_authentication(:consumer)
  end
  
  def token_authentication(class_name)
    authenticate_or_request_with_http_basic  do |username, password|
      user = User.find_by(username: username, password: password)
      if user 
        true
      else
        false
      end
    end
  end
end
