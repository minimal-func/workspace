class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friendship, only: [:accept, :destroy]

  def index
    @friends = current_user.friends.order(:email)
    @incoming_friendships = current_user.received_friendships.pending.includes(:requester)
    @outgoing_friendships = current_user.sent_friendships.pending.includes(:addressee)
    @query = params[:q].to_s.strip
    @users = searchable_users if @query.present?
  end

  def create
    addressee = User.find(params[:user_id])

    if addressee == current_user
      redirect_to friendships_path, alert: "You can't add yourself as a friend."
      return
    end

    if Friendship.between(current_user, addressee).exists?
      redirect_to friendships_path(q: addressee.email), alert: "A friendship or friend request already exists."
      return
    end

    friendship = current_user.sent_friendships.create(addressee: addressee)
    if friendship.persisted?
      addressee.notifications.create!(
        notifiable: friendship,
        message: "#{current_user.email} sent you a friend request."
      )
      redirect_to friendships_path, notice: "Friend request sent to #{addressee.email}."
    else
      redirect_to friendships_path(q: addressee.email), alert: friendship.errors.full_messages.to_sentence
    end
  end

  def accept
    unless @friendship.pending? && @friendship.addressee == current_user
      redirect_to friendships_path, alert: "That friend request can't be accepted."
      return
    end

    @friendship.accept!
    @friendship.requester.notifications.create!(
      notifiable: @friendship,
      message: "#{current_user.email} accepted your friend request."
    )
    redirect_to friendships_path, notice: "You and #{@friendship.requester.email} are now friends."
  end

  def destroy
    friend = @friendship.other_user(current_user)
    was_pending = @friendship.pending?
    @friendship.destroy!
    message = was_pending ? "Friend request removed." : "#{friend.email} was removed from your friends."
    redirect_to friendships_path, notice: message
  end

  private

  def set_friendship
    @friendship = current_user.all_friendships.find(params[:id])
  end

  def searchable_users
    User.where("email ILIKE ?", "%#{User.sanitize_sql_like(@query)}%")
        .where.not(id: current_user.id)
        .order(:email)
        .limit(20)
  end
end
