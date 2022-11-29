class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
    if current_user.nil?  then
      redirect_to new_user_session_path
    end
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to item_url(@item), notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_lending

    @item2 = Item.find(params[:item_id])

    @user = current_user

    @lending = Lending.where(item_id: @item2.id, completed_at: nil)[0]
    if @lending.nil?
      @lending = Lending.new()
      @lending.started_at = DateTime.now
      @lending.due_at = @lending.started_at + @item2.max_borrowing_period
      @lending.user = @user
      @lending.item = @item2
      @lending.completed_at = nil
      msg = "Item was successfully borrowed"
    else 
      @lending.completed_at = DateTime.now
      msg = "Item was successfully returned"
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

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to item_url(@item), notice: "Item was successfully updated." }
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
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :description, :max_borrowing_period)
    end
end
