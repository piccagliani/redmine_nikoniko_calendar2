# Niko-niko Calendar plugin for Redmine 2.X
# Copyright (C) 2013 gliani
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

  def initialize
    super
    @today = Date.today
  end

  def index
    # get parameter
    if params[:year] and params[:year].to_i > 1900
      year = params[:year].to_i
      if params[:month] and 0 < params[:month].to_i and params[:month].to_i < 13
        month = params[:month].to_i
      end
    end
    year ||= Date.today.year
    month ||= Date.today.month
    
    # get project
    project_id = params[:project_id]
    @project = Project.find(project_id)

    # create calendar
    @target_month = Date.civil(year, month, 1);
    @calendar = Redmine::Helpers::Calendar.new(@target_month, current_language, :month)
    
    # get members of project
    @members = User.find(
      :all, 
      :conditions => ["projects.identifier = ?", project_id], 
      :order => "users.id asc",
      :include => {:members => [:project]}
    )
    
    # get member's nikoniko
    @nikoniko_histories = {}
    nikoniko_histories_tmp = NikonikoHistory.find_with_project_and_member(project_id, @calendar.startdt, @calendar.enddt + 6)
    nikoniko_histories_tmp.each do |n|
      @nikoniko_histories[n.user_id] = {} if @nikoniko_histories[n.user_id] == nil
      @nikoniko_histories[n.user_id][n.date.to_s] = n
    end
    logger.info(@nikoniko_histories);
  end
end
