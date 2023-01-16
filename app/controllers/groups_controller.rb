class GroupsController < ApplicationController
  before_action :assure_signed_in
  before_action :set_user_group
  before_action :set_group, only: %i[ edit update destroy ]
  before_action :set_group_from_id, only: %i[ remove_user add_user ]
  before_action :assure_admin, only: %i[ edit update destroy remove_user add_user ]

  # GET /groups or /groups.json
  def index
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        Membership.create(user: current_user, group: @group, role: :admin)
        format.html { redirect_to groups_url, notice: t(:group_new) }
        format.json { render :show, status: :created, location: @group }
      else
        unprocessable_response(format, redirect: :index, entity: @group)
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to edit_group_url(@group), notice: t(:group_update) }
        format.json { render :show, status: :ok, location: @group }
      else
        unprocessable_response(format, redirect: :edit, entity: @group)
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.memberships.each(&:destroy)
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url, notice: t(:group_destroy) }
      format.json { head :no_content }
    end
  end

  # POST /groups/1/leave or /groups/1/leave.json
  def leave
    respond_to do |format|
      if current_user.memberships.destroy_by(group_id: params[:group_id])
        format.html { redirect_to groups_url, notice: t(:group_update) }
        format.json { head :no_content }
      else
        unprocessable_response(format, redirect: :edit, entity: @group)
      end
    end
  end

  # PATCH /groups/1/remove_user or /groups/1/remove_user.json
  def remove_user
    user = User.find(params[:user])
    respond_to do |format|
      if user.memberships.destroy_by(group: @group)
        format.html { redirect_to edit_group_path(@group), notice: t(:group_update) }
        format.json { head :no_content }
      else
        unprocessable_response(format, redirect: :edit, entity: @group)
      end
    end
  end

  # PATCH /groups/1/add_user or /groups/1/add_user.json
  def add_user
    respond_to do |format|
      user = User.where(email: params[:user][:email]).first
      if Membership.where(user: user, group: @group, role: :member).first_or_create
        format.html { redirect_to edit_group_url(@group), notice: t(:group_update) }
        format.json { head :no_content }
      else
        unprocessable_response(format, redirect: :edit, entity: @group)
      end
    end
  end

  private

  def assure_signed_in
    unless user_signed_in?
      redirect_to new_user_session_path, notice: t(:login_first)
      return false
    end
    true
  end

  def assure_admin
    assure_signed_in
    unless current_user.admin_in? @group
      redirect_to groups_url, notice: t(:only_admins)
      return false
    end
    true
  end

  def set_user_group
    @user = current_user
    @groups = current_user.groups
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  def set_group_from_id
    @group = Group.find(params[:group_id])
  end

  def unprocessable_response(format, redirect:, entity:)
    format.html { render redirect, status: :unprocessable_entity }
    format.json { render json: entity.errors, status: :unprocessable_entity }
  end

  # Only allow a list of trusted parameters through.
  def group_params
    params.require(:group).permit(:name)
  end
end
