# rubocop:disable Metrics/ClassLength
class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :set_item_from_item_id, only: %i[ update_lending ]

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
    @item = Item.new
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

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)

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

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def update_lending
    @user = current_user

    @lending = Lending.where(item_id: @item.id, completed_at: nil)[0]
    @item.lat = params[:lat]
    @item.lng = params[:lng]
    @item.save

    if @lending.nil?
      create_lending
      msg = I18n.t("items.messages.successfully_borrowed")
    else
      @lending.completed_at = DateTime.now
      msg = I18n.t("items.messages.successfully_returned")
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
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to item_url(@item), notice: I18n.t("items.messages.successfully_updated") }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

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
  def item_params
    params.require(:item).permit(:name, :description, :max_borrowing_days)
  end

  def create_lending
    @lending = Lending.new
    @lending.started_at = DateTime.now
    @lending.due_at = @lending.started_at.next_day(@max_borrowing_days)
    @lending.user = @user
    @lending.item = @item
    @lending.completed_at = nil
  end
end
# rubocop:enable Metrics/ClassLength
