# rubocop:disable Metrics/ClassLength
class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :set_item_from_item_id, only: %i[ update_lending reserve ]
  helper_method :button_text, :button_path

  # GET /items or /items.json
  def index
    @q = Item.ransack(params[:q])
    @items = @q.result(distinct: true)
  end

  # GET /items/1 or /items/1.json
  def show
    @src_is_qrcode = params[:src] == "qrcode"

    return unless current_user.nil?

    redirect_to new_user_session_path
  end

  def download
    @item = Item.find(params[:id])
    send_data @item.to_pdf, filename: "item.pdf"
  end

  # GET /items/new
  def new
    @item = Item.new(item_type: params[:item_type])
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    @item = Item.new(item_params(params[:item_type]))
    @item.item_type = params[:item_type]

    #unless Group.exists?(name: "Default Group")
    #@testGroup = Group.new(name: "Default Group")
    #@testGroup.save
    #end

    #@testGroup = Group.where(name: "Default Group").first
    #@testMembership = Membership.new(role: 1, user_id: current_user.id, group: @testGroup)
    #@testMembership.save
    #user_memberships = current_user.memberships
    #user_memberships.push(@testMembership)
    #current_user.save
    #item_groups = @item.borrower_groups
    #item_groups.push(@testGroup)

    respond_to do |format|
      if @item.save
        format.html { redirect_to item_url(@item), notice: I18n.t("items.messages.successfully_created") }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def update_lending
    @user = current_user

    @item.lat = params[:lat]
    @item.lng = params[:lng]
    @item.save

    if @item.borrowable_by?(@user)
      create_lending
      msg = I18n.t("items.messages.successfully_borrowed")
    elsif @item.borrowed_by?(@user)
      @lending = Lending.where(item_id: @item.id,user_id: @user.id, completed_at: nil).first
      @lending.completed_at = Time.zone.now
      msg = I18n.t("items.messages.successfully_returned")
    else
      msg = I18n.t("items.messages.lending_error")
    end

    if @item.reserved_by?(@user)
      @reservation = @item.current_reservation
      @reservation.ends_at = Time.zone.now
      @reservation.save
    end

    respond_to do |format|
      if @lending.save
        format.html { redirect_to items_path, notice: msg }
        format.json { render :index, status: :ok, location: items_path }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @lending.errors, status: :unprocessable_entity }
      end
    end
  end

  def reserve
    @user = current_user
    item_reservable_by_user = @item.reservable_by?(@user)
    if item_reservable_by_user
      create_reservation
      msg = I18n.t("items.messages.successfully_reserved")
    else
      msg = I18n.t("items.messages.unsuccessfully_reserved")
    end

    respond_to do |format|
      if !item_reservable_by_user or @reservation.save
        format.html { redirect_to @item, notice: msg }
        format.json { render @item, status: :ok, location: @item }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params(params[:item_type]))
        format.html { redirect_to item_url(@item), notice: I18n.t("items.messages.successfully_updated") }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url, notice: I18n.t("items.messages.successfully_destroyed") }
      format.json { head :no_content }
    end
  end

  def button_path
    return item_update_lending_path(@item) if (@item.borrowable_by?(current_user) or @item.borrowed_by?(current_user)) and @src_is_qrcode
    item_reserve_path(@item) if @item.reservable_by?(current_user) and !@src_is_qrcode
  end

  def button_text
    return I18n.t("items.buttons.reserve") if @item.reservable_by?(current_user) and !@src_is_qrcode
    return I18n.t("items.buttons.borrow") if @item.borrowable_by?(current_user) and @src_is_qrcode
    return I18n.t("items.buttons.return") if @item.borrowed_by?(current_user) and @src_is_qrcode

    I18n.t("items.status_badge.not_available")
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  def set_item_from_item_id
    @item = Item.find(params[:item_id])
  end

  # Only allow a list of trusted parameters through.
  # rubocop:disable Metrics/MethodLength
  def item_params(item_type)
    case item_type
    when "book"
      params.require(:item).permit(:item_type, :name, :isbn, :author, :release_date, :genre, :language,
                                   :number_of_pages, :publisher, :edition, :description, :max_borrowing_days, :max_reservation_days)
    when "movie"
      params.require(:item).permit(:item_type,  :name, :director, :release_date, :format, :genre, :language, :fsk,
                                   :description, :max_borrowing_days, :max_reservation_days)
    when "game"
      params.require(:item).permit(:item_type,  :name, :author, :illustrator, :publisher, :number_of_players,
                                   :playing_time, :language, :description, :max_borrowing_days, :max_reservation_days)
    else
      item_type.eql?("other")
      params.require(:item).permit(:item_type, :name, :category, :description, :max_borrowing_days, :max_reservation_days)
    end
  end
  # rubocop:enable Metrics/MethodLength

  def create_lending
    @lending = Lending.new
    @lending.started_at = DateTime.now
    @lending.due_at = @lending.started_at.next_day(@max_borrowing_days)
    @lending.user = @user
    @lending.item = @item
    @lending.completed_at = nil
  end

  def create_reservation
    @reservation = Reservation.new(item_id: @item.id, user_id: @user.id, starts_at: Time.current, ends_at: Time.current + @item.max_reservation_days.days )
  end
end
# rubocop:enable Metrics/ClassLength
