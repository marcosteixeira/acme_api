class ApplicationController < ActionController::API
	before_filter :user_quota

	def user_quota
    Hit.transaction do
      Hit.create(user: current_user, endpoint: request.path)
      render json: { error: 'over quota' } if current_user.count_hits >= 10000
    end
  end
end
