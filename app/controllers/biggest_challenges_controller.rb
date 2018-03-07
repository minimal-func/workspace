class BiggestChallengesController < ApplicationController
  def index
    @biggest_challenges = current_user.biggest_challenges.order(created_at: :desc)
  end
end
