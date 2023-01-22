class MembershipsController < ApplicationController
  before_action :set_group
  before_action :assure_admin

  # PATCH /groups/1/remove_user or /groups/1/remove_user.json
  def remove_user
    user = User.find(params[:user])
    respond_to do |format|
      if user.memberships.destroy_by(group: @group)
        respond_with_notice(format, redirect: edit_group_path(@group), notice: t(:group_user_removed))
      else
        unprocessable_response(format, redirect: :edit, entity: @group)
      end
    end
  end

  # PATCH /groups/1/add_user or /groups/1/add_user.json
  def add_user
    respond_to do |format|
      user = User.where(email: params[:user][:email]).first
      if user.blank?
        respond_with_notice(format, redirect: edit_group_url(@group), notice: t(:group_user_not_found))
      elsif Membership.where(user: user, group: @group, role: :member).first_or_create
        respond_with_notice(format, redirect: edit_group_url(@group), notice: t(:group_user_added))
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

  def set_group
    @group = Group.find(params[:group_id])
  end

  def respond_with_notice(format, redirect:, notice:)
    format.html { redirect_to redirect, notice: notice }
    format.json { head :no_content }
  end
end
