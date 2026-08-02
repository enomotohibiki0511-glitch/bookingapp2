class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reservations = current_user.reservations.includes(:room).order(created_at: :desc)
  end

  def new
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new
  end

  def confirm
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new(reservation_params)
    @reservation.user = current_user
    @reservation.room = @room

    if @reservation.valid?
      @nights = (@reservation.checkout_at - @reservation.checkin_at).to_i
      @total_price = @room.price * @nights * @reservation.guest_count
    else
      flash.now[:alert] = "予約内容に誤りがあります。"
      render :new, status: :unprocessable_entity
    end
  end

  def create
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new(reservation_params)
    @reservation.user = current_user
    @reservation.room = @room

    if @reservation.save
      redirect_to reservations_path, notice: "予約が完了しました。"
    else
      flash.now[:alert] = "予約に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:checkin_at, :checkout_at, :guest_count)
  end
end