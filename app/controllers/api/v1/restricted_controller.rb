class Api::V1::RestrictedController < Api::V1::BaseController
  before_filter :authentication_required

end
