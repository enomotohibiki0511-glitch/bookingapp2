class RoomsController < ApplicationController
  before_action :authenticate_user!, except: [ :show, :search ]

  def index
    @rooms = current_user.rooms.order(created_at: :desc)
  end

  def show
    @room = Room.find(params[ :id ])
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.new(room_params)

    if @room.save
      redirect_to @room, notice: "施設を登録しました。"
    else
      flash.now[ :alert ] = "施設の登録に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def search
    @rooms = Room.all

    if params[ :area ].present?
      @rooms = @rooms.where("address LIKE ?", "%#{params[ :area ]}%")
    end

    if params[ :keyword ].present?
      @rooms = @rooms.where("name LIKE :kw OR description LIKE :kw", kw: "%#{params[ :keyword ]}%")
    end

    @rooms_count = @rooms.count
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end
end
