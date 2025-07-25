class BiggestChallengesController < ApplicationController
  def index
    @pagy, @biggest_challenges = pagy(current_user.biggest_challenges.order(created_at: :desc), items: 10)
  end
end
