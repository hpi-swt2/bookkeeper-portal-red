# rubocop:disable Metrics/ClassLength
class ItemsController < ApplicationController
  include ActionController::MimeResponds

  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :set_item_from_item_id, only: %i[ borrow reserve give_back join_waitlist leave_waitlist]
  helper_method :button_text, :button_path

  # GET /items or /items.json
  def index
    @items = apply_sort_and_filter(Item.all)
  end

  # GET /items/1 or /items/1.json
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def show
    @item = Item.find(params[:id])
    @src_is_qrcode = params[:src] == "qrcode"

    if current_user.nil?
      redirect_to new_user_session_path
    elsif !current_user.can_view?(@item)
      respond_to do |format|
        format.html { redirect_to items_path, notice: I18n.t("items.messages.not_allowed_to_access") }
        format.json { head :no_content }
      end
    end

    # Usually reservations from the waitlist are automatically created
    # by a scheduled job when the previous reservation expires.
    # However, since the job runs not constantly, there might be an edge
    # case where a previous reservation has expired and there are people
    # on the waitlist, but the job has had no chance to create a reservation
    # for them yet. In order to prevent other people from "stealing the reservation"
    # without being on the waitlist during this interval, we do the same
    # check as the job before showing the item page to the user.
    @item.create_reservation_from_waitlist

    return unless current_user.nil?

    redirect_to new_user_session_path
  end
  # rubocop:enable Metrics/MethodLength

  def download
    @item = Item.find(params[:id])
    if current_user.can_manage?(@item)
      send_data @item.to_pdf(request.host), filename: "item.pdf"
    else
      respond_to do |format|
        format.html { redirect_to @item, status: :forbidde, nnotice: I18n.t("items.messages.not_allowed_to_download") }
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
    items = current_user.lendings.where(completed_at: nil).map(&:item)
    @items = apply_sort_and_filter(items)
    render :borrowed_items
  end

  # GET /items/my/borrowed
  # lists all items of the current user which are currently borrowed
  def mine_borrowed
    # return items which are currently not lendable
    items = current_user.items.filter(&:borrowed?)
    @items = apply_sort_and_filter(items)
    render :borrowed_items
  end

  # GET /items/my
  # lists all items of the current user
  def my_items
    items = current_user.items
    @items = apply_sort_and_filter(items)
  end

  # GET /items/export_csv
  # export current items to csv
  def export_csv
    @items = apply_sort_and_filter(Item.all)
    send_data CsvExport.to_csv(@items), filename: "items.csv"
  end

  # POST /items or /items.json
  # rubocop:disable Metrics/MethodLength
  def create
    @item = Item.new(item_params(params[:item_type]))
    @item.item_type = params[:item_type]
    item_saved = @item.save
    create_permission

    respond_to do |format|
      if item_saved
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
    put_item_location(params)
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
    put_item_location(params)

    if @item.borrowed_by?(@user)
      @lending = Lending.where(item_id: @item.id, user_id: @user.id, completed_at: nil).first
      @lending.completed_at = Time.current
      @item.create_reservation_from_waitlist
      msg = I18n.t("items.messages.successfully_returned")
    elsif @item.borrowed? && @user.can_manage?(@item)
      @lending = Lending.where(item_id: @item.id, completed_at: nil).first
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

  def put_item_location(params)
    if params[:lat_s].present? && params[:lng_s].present?
      @item.lat = params[:lat_s]
      @item.lng = params[:lng_s]
    else
      @item.lat = params[:lat_l]
      @item.lng = params[:lng_l]
    end
    @item.save
  end

  # PATCH
  def reserve
    @user = current_user
    item_reservable_by_user = @item.reservable_by?(@user)
    if item_reservable_by_user
      @reservation = @item.create_reservation(@user)
      msg = I18n.t("items.messages.successfully_reserved")
    else
      msg = I18n.t("items.messages.unsuccessfully_reserved")
    end

    respond_to do |format|
      if !item_reservable_by_user || @reservation.errors.empty?
        format.html { redirect_to @item, notice: msg }
        format.json { render @item, status: :ok, location: @item }
      else
        format.html { render :show, status: :unprocessable_entity, notice: msg }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH
  def join_waitlist
    @user = current_user
    can_join_waitlist = @item.allows_joining_waitlist?(@user)
    waiting_position = WaitingPosition.new(item_id: @item.id, user_id: @user.id)

    respond_to do |format|
      if can_join_waitlist && waiting_position.save
        format.html { redirect_to @item, notice: I18n.t("items.messages.joining_waitlist_succeeded") }
        format.json { render @item, status: :ok, location: @item }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: waiting_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # PATCH
  def leave_waitlist
    @user = current_user
    WaitingPosition.find_by(user_id: @user.id, item_id: @item.id)&.destroy

    respond_to do |format|
      format.html { redirect_to @item, notice: I18n.t("items.messages.leaving_waitlist_succeeded") }
      format.json { render @item, status: :ok, location: @item }
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def update
    respond_to do |format|
      @item.item_type = params[:item_type]
      create_permission
      if @item.update(item_params(params[:item_type]))
        format.html { redirect_to item_url(@item), notice: I18n.t("items.messages.successfully_updated") }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

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

  def permissions
    # A bit janky but otherwise it selects the id of the personal_group instead of the permissions id
    associated_permissions = Group.joins(:permissions)
                                  .where.not('groups.tag': "personal_group")
                                  .or(Group.joins(:permissions).where('groups.tag': nil))
                                  .select('permissions.id', Permission.attribute_names.reject do |attribute_name|
                                                              attribute_name == 'id'
                                                            end)
                                  .where('permissions.item_id': params["id"])
    respond_to do |format|
      format.json { render json: associated_permissions }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  def set_item_from_item_id
    @item = Item.find(params[:item_id])
  end

  def apply_sort_and_filter(items)
    # ransack only works on ActiveRecord::Relation, not on arrays.
    # Sometimes items is a relation, sometimes an array, so we have to
    # ensure it's converted to a relation
    items_relation = Item.where(id: items.map(&:id))
    @q = items_relation.ransack(params[:q])
    @q.result(distinct: true)
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
      params.require(:item).permit(:item_type, :name, :director, :release_date, :format, :genre, :language, :fsk,
                                   :description, :max_borrowing_days, :max_reservation_days)
    when "game"
      params.require(:item).permit(:item_type, :name, :author, :illustrator, :publisher, :fsk, :number_of_players,
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
    @lending.due_at = @lending.started_at.next_day(@item.max_borrowing_days)
    @lending.user = @user
    @lending.item = @item
    @lending.completed_at = nil
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create_permission
    @item.permissions.clear
    permissions = []
    params.each do |key, value|
      next unless key.start_with?("permission_")

      index = key.split("_")[1].to_i * 2
      if key.split("_")[2] == "group"
        permissions[index] = value.to_i
      else
        permissions[index + 1] = Permission.permission_types[value]
      end
    end

    permissions.each_slice(2) do |group_id, level|
      Permission.create(item_id: @item.id, group_id: group_id, permission_type: level)
    end

    personal_group = current_user.personal_group
    Permission.create(item_id: @item.id, group_id: personal_group.id, permission_type: :can_manage)
  end

  def create_reservation
    @reservation = Reservation.new(item_id: @item.id, user_id: @user.id, starts_at: Time.current,
                                   ends_at: Time.current + @item.max_reservation_days.days)
  end
end

# rubocop:enable Metrics/ClassLength, Metrics/MethodLength, Metrics/AbcSize
