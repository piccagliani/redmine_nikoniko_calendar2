# Niko-niko Calendar plugin for Redmine 2.X
# Copyright (C) 2013 piccagliani
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
class NikonikoCalendarProjectController < ApplicationController
  unloadable

  menu_item :nikoniko_calendar_project
    
  def initialize
    super
    @today = Date.today
  end

  def index
    # get project
    project_id = params[:project_id]
    @project = Project.find(project_id)
    
    @roles =  Role.find_all_givable
  end

  def history
    # get parameter
    if params[:year] and params[:year].to_i > 1900
      year = params[:year].to_i
      if params[:month] and 0 < params[:month].to_i and params[:month].to_i < 13
        month = params[:month].to_i
      end
    end
    year ||= Date.today.year
    month ||= Date.today.month

    if params[:role] and 0 < params[:role].length
      role_ids = params[:role].split(",")
    end

    # get project
    project_id = params[:project_id]
    @project = Project.find(project_id)

    # create calendar
    @target_month = Date.civil(year, month, 1);
    @calendar = Redmine::Helpers::Calendar.new(@target_month, current_language, :month)
    @prev_month = @target_month << 1
    @next_month = @target_month >> 1

    # get members of project
    conditions = "projects.identifier = :project_id"
    binds = {:project_id => project_id}

    if role_ids != nil
      conditions += " and member_roles.role_id in (:role_ids)"
      binds[:role_ids] = role_ids
    end

    @members = User.find(
      :all,
      :conditions => [conditions, binds],
      :order => "users.id asc",
      :include => {:members => [:project, :member_roles]}
    )

    # get member's nikoniko
    @nikoniko_histories = {}
    nikoniko_histories_tmp = NikonikoHistory.find_with_project_and_member(project_id, @calendar.startdt, @calendar.enddt + 6, role_ids)
    nikoniko_histories_tmp.each do |n|
      @nikoniko_histories[n.user_id] = {} if @nikoniko_histories[n.user_id] == nil
      @nikoniko_histories[n.user_id][n.date.to_s] = n
    end

    render :layout => false if request.xhr?
  end
end
