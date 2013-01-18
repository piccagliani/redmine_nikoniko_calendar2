class NikonikoHistory < ActiveRecord::Base
  unloadable
  
  belongs_to :user

  def self.find_with_project_and_member(project_id, start_date, end_date)
    logger.info(project_id)
    self.find(
      :all,
      :conditions => ["projects.identifier = :project_id and :start_date <= nikoniko_histories.date and nikoniko_histories.date <= :end_date", { 
        :project_id => project_id,
        :start_date => start_date,
        :end_date => end_date
      }],
      :order => "nikoniko_histories.user_id asc, nikoniko_histories.date asc", 
      :include => {:user => {:members => [:project]}}
    )
  end
end
