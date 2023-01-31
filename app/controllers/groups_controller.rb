class GroupsController < ApplicationController
  before_action :assure_signed_in, :set_user_group
  before_action :set_group, :assure_admin, only: %i[ edit update destroy ]

  # GET /groups or /groups.json
  def index
  end

  def all
    personal_groups = Group.where(tag: :personal_group)

    respond_to do |format|
      format.json { render json: Group.all - personal_groups }
    end
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
        respond_with_notice_and_status(format, redirect: groups_url, notice: t(:group_new),
                                               status: :created)
      else
        unprocessable_response(format, redirect: :index, entity: @group)
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        respond_with_notice_and_status(format, redirect: edit_group_url(@group), notice: t(:group_update), status: :ok)
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
      respond_with_notice(format, redirect: groups_url, notice: t(:group_destroy))
    end
  end

  # POST /groups/1/leave or /groups/1/leave.json
  def leave
    respond_to do |format|
      if current_user.memberships.destroy_by(group_id: params[:group_id])
        respond_with_notice(format, redirect: groups_url, notice: t(:group_update))
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

  def set_group
    @group = Group.find(params[:id])
  end

  def unprocessable_response(format, redirect:, entity:)
    format.html { render redirect, status: :unprocessable_entity }
    format.json { render json: entity.errors, status: :unprocessable_entity }
  end

  def respond_with_notice(format, redirect:, notice:)
    format.html { redirect_to redirect, notice: notice }
    format.json { head :no_content }
  end

  def respond_with_notice_and_status(format, redirect:, notice:, status:)
    format.html { redirect_to redirect, notice: notice }
    format.json { render :show, status: status, location: @group }
  end

  # Only allow a list of trusted parameters through.
  def group_params
    params.require(:group).permit(:name)
  end
end
