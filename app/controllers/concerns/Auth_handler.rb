module AuthHandler

  def encode_token(payload)
    JWT.encode(payload.merge(expires_at: (Time.current + 12.hour).to_i), ENV['SECRET'])
  end

  def decoded_token
    token = request.headers['Authorization']
    if token
      begin
        JWT.decode(token, ENV['SECRET'])
      rescue JWT::DecodeError
        nil
      end
    else
      nil
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user ||= User.includes(:roles).find_by(id: user_id)
    end
  end
 
  def is_logged_in
    current_user
  end
 
  def authorize
    token = decoded_token[0]['expires_at'] if decoded_token && decoded_token.is_a?(Array)
    if token
      if validate_token_time(token)
        render json: { message: 'Login Required' }, status: :unauthorized unless (is_logged_in.is_a? User)
      else
        error_response('Session expired. Please login again')
      end
    else
      error_response('Auth Token Required')
    end
  end

  private

  def validate_token_time(time)
    Time.current < Time.at(time)
  end
end
