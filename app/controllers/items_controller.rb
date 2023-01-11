# rubocop:disable Metrics/ClassLength
class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :set_item_from_item_id, only: %i[ borrow reserve give_back]
  helper_method :button_text, :button_path

  # GET /items or /items.json
  def index
    @q = Item.ransack(params[:q])
    @items = @q.result(distinct: true)
  end

  # GET /items/1 or /items/1.json
  def show
    @item = Item.find(params[:id])
    @src_is_qrcode = params[:src] == "qrcode"

    return unless current_user.nil?

    redirect_to new_user_session_path
  end

  def download
    @item = Item.find(params[:id])
    if current_user.can_manage?(@item)
      send_data @item.to_pdf, filename: "item.pdf"
    else
      respond_to do |format|
        format.html { redirect_to @item, notice: I18n.t("items.messages.not_allowed_to_download") }
        format.json { head :no_content }
      end
    end
  end

  # GET /items/new
  def new
    @item = Item.new(item_type: params[:item_type])
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    return if current_user.can_manage?(@item)

    respond_to do |format|
      format.html { redirect_to @item, notice: I18n.t("items.messages.not_allowed_to_edit") }
      format.json { head :no_content }
    end
  end

  # GET /items/borrowed
  # lists all items borrowed by the current user
  def borrowed_by_me
    @items = current_user.lendings.where(completed_at: nil).map(&:item)
    render :borrowed_items
  end

  # GET /items/my/borrowed
  # lists all items of the current user which are currently borrowed
  def mine_borrowed
    # return items which are currently not lendable
    @items = current_user.items.filter(&:borrowed?)
    render :borrowed_items
  end

  # GET /items/my
  # lists all items of the current user
  def my_items
    @items = current_user.items
  end

  # POST /items or /items.json
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    @item = Item.new(item_params(params[:item_type]))
    @item.item_type = params[:item_type]

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

  # PATCH
  def borrow
    @user = current_user
    @item.lat = params[:lat]
    @item.lng = params[:lng]
    @item.save
    if @item.borrowable_by?(@user)
      create_lending
      msg = I18n.t("items.messages.successfully_borrowed")
    else
      msg = I18n.t("items.messages.lending_error")
    end

    @item.cancel_reservation_for(@user)

    respond_to do |format|
      if @lending&.save
        format.html { redirect_to @item, notice: msg }
        format.json { render :index, status: :ok, location: @item }
      else
        format.html { render @item, status: :unprocessable_entity, notice: msg }
        format.json { render json: @lending.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH
  def give_back
    @user = current_user
    @item.lat = params[:lat]
    @item.lng = params[:lng]
    @item.save

    if @item.borrowed_by?(@user)
      @lending = Lending.where(item_id: @item.id, user_id: @user.id, completed_at: nil).first
      @lending.completed_at = Time.current
      msg = I18n.t("items.messages.successfully_returned")
    elsif @item.borrowed? && @user.can_manage?(@item)
      @lending = Lending.where(item_id: @item.id, user_id: @user.id, completed_at: nil).first
      @lending.completed_at = Time.current
      msg = I18n.t("items.messages.successfully_returned-by-owner")
    else
      msg = I18n.t("items.messages.lending_error")
    end

    respond_to do |format|
      if @lending&.save
        format.html { redirect_to @item, notice: msg }
        format.json { render :index, status: :ok, location: @item }
      else
        format.html { redirect_to @item, status: :unprocessable_entity, notice: msg }
        format.json { render json: @lending.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH
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
      if !item_reservable_by_user || @reservation.save
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
  # rubocop:disable Metrics/AbcSize
  def update
    respond_to do |format|
      @item.item_type = params[:item_type]
      if @item.update(item_params(params[:item_type]))
        format.html { redirect_to item_url(@item), notice: I18n.t("items.messages.successfully_updated") }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  # DELETE /items/1 or /items/1.json
  # rubocop:disable Metrics/MethodLength
  def destroy
    if current_user.can_manage?(@item)
      @item.destroy
      msg = I18n.t("items.messages.successfully_destroyed")
      redirect_path = items_path
    else
      msg = I18n.t("items.messages.not_allowed_to_destroy")
      redirect_path = @item
    end

    respond_to do |format|
      format.html { redirect_to redirect_path, notice: msg }
      format.json { head :no_content }
    end
  end
  # rubocop:enable Metrics/MethodLength

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
                                   :number_of_pages, :publisher, :edition, :description, :max_borrowing_days,
                                   :max_reservation_days)
    when "movie"
      params.require(:item).permit(:item_type,  :name, :director, :release_date, :format, :genre, :language, :fsk,
                                   :description, :max_borrowing_days, :max_reservation_days)
    when "game"
      params.require(:item).permit(:item_type,  :name, :author, :illustrator, :publisher, :fsk, :number_of_players,
                                   :playing_time, :language, :description, :max_borrowing_days, :max_reservation_days)
    else
      item_type.eql?("other")
      params.require(:item).permit(:item_type, :name, :category, :description, :max_borrowing_days,
                                   :max_reservation_days)
    end
  end
  # rubocop:enable Metrics/MethodLength

  def create_lending
    @lending = Lending.new
    @lending.started_at = Time.current
    @lending.due_at = @lending.started_at.next_day(@max_borrowing_days)
    @lending.user = @user
    @lending.item = @item
    @lending.completed_at = nil
  end

  def create_reservation
    @reservation = Reservation.new(item_id: @item.id, user_id: @user.id, starts_at: Time.current,
                                   ends_at: Time.current + @item.max_reservation_days.days)
  end
end
# rubocop:enable Metrics/ClassLength
