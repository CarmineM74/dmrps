class RablResponder < ActionController::Responder
  def to_json
    case 
    when has_errors?
      controller.response.status = :unprocessable_entity
    when post?
      controller.response.status = :created
    end
    default_render 
  end
end
