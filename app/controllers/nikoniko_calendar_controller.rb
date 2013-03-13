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
class NikonikoCalendarController < ApplicationController
  unloadable
  def initialize
    super
    @today = Date.today
  end

  def index
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

    # create calendar
    @target_month = Date.civil(year, month, 1);
    @calendar = Redmine::Helpers::Calendar.new(@target_month, current_language, :month)
    @prev_month = @target_month << 1
    @next_month = @target_month >> 1

    # get user's nikoniko
    @nikoniko_history = {};
    nikoniko_history_tmp = NikonikoHistory.find(
      :all, 
      :conditions => ["user_id = :user_id AND :start_date <= date AND date <= :end_date", {
        :user_id => User.current.id,
        :start_date => @calendar.startdt.to_s,
        :end_date => @calendar.enddt.to_s
      }],
      :order => "date ASC"
    )
    nikoniko_history_tmp.each do |n|
      @nikoniko_history[n.date.to_s] = n
    end
    
    # get average
    @nikoniko_average = NikonikoHistory.get_average_for_user(User.current.id, @target_month, @next_month - 1)
    
    # get summary
    @nikoniko_summary = NikonikoHistory.get_summary_for_user(User.current.id, @target_month, @next_month - 1)

    render :layout => false if request.xhr?
  end

  def post
    date = params[:date]
    comment = params[:comment]
    niko = params[:niko]

    dateArr = date.split("-")
    target_date = Date.civil(dateArr[0].to_i, dateArr[1].to_i, dateArr[2].to_i)

    if target_date <= @today
      nikoniko_history = NikonikoHistory.find_by_user_id_and_date(User.current.id, target_date)
      if nikoniko_history == nil
        NikonikoHistory.create(:user_id => User.current.id, :date => target_date, :niko => niko, :comment => comment)
      else
        nikoniko_history.niko = niko
        nikoniko_history.comment = comment
        nikoniko_history.save()
      end
    end
    
    render :layout => false
  end
end
