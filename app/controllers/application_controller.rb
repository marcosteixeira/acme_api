# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :user_quota

  def user_quota
    Hit.transaction do
      Hit.create(user: current_user, endpoint: request.path)
      render json: { error: 'over quota' } if current_user.count_hits >= 10_000
    end
  end

  def current_user
    # omitting authentication for simplicity
    raise NotImplementedError
  end
end
