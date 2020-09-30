module Response

  def render_success(json, **extra_meta)
    response = { code: 200, message: "success", data: json }.merge(extra_meta)
    render json: response
  end

  def error_response(error, status = 404)
    json_response = { code: status, message: error }
    render json: json_response, status: status
  end
end
