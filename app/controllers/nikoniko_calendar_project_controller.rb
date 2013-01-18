class NikonikoCalendarProjectController < ApplicationController
  unloadable


  def index
    project_id = params[:project_id]
    @project = Project.find(project_id)
    
    @today = Date.today
    @start_date = Date.commercial(@today.year, @today.cweek) - 1
    
    # get members of project
    @members = User.find(
      :all, 
      :conditions => ["projects.identifier = ?", project_id], 
      :order => "users.id asc",
      :include => {:members => [:project]}
    )
    
    # get member's nikoniko
    @nikoniko_histories = {}
    nikoniko_histories_tmp = NikonikoHistory.find_with_project_and_member(project_id, @start_date, @start_date + 6)
    nikoniko_histories_tmp.each do |n|
      @nikoniko_histories[n.user_id] = {} if @nikoniko_histories[n.user_id] == nil
      @nikoniko_histories[n.user_id][n.date.to_s] = n
    end
    logger.info(@nikoniko_histories);
  end
  
  
  private
  def last_sunday(date)
    
  end
end
