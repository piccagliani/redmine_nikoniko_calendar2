class NikonikoHistory < ActiveRecord::Base
  unloadable

  belongs_to :user
  def self.find_with_project_and_member(project_id, start_date, end_date)
    self.find(
      :all,
      :conditions => ["projects.identifier = :project_id and :start_date <= nikoniko_histories.date and nikoniko_histories.date <= :end_date", {
          :project_id => project_id,
          :start_date => start_date.to_s,
          :end_date => end_date.to_s
        }],
      :order => "nikoniko_histories.user_id asc, nikoniko_histories.date asc",
      :include => {:user => {:members => [:project]}}
    )
  end

  def self.get_average_for_user(user_id, start_date, end_date)
    result = self.find(
      :all,
      :select => "avg(niko) AS niko",
      :conditions => ["user_id = :user_id AND :start_date <= date AND date <= :end_date", {
          :user_id => user_id,
          :start_date => start_date.to_s,
          :end_date => end_date.to_s
        }],
    )
    average = result[0].niko == nil ? 0.0 : (result[0].niko / 3.0 * 1000).round / 10.0
  end

  def self.get_summary_for_user(user_id, start_date, end_date)
    result = self.find(
      :all,
      :select => "niko, COUNT(id) AS count",
      :conditions => ["user_id = :user_id AND :start_date <= date AND date <= :end_date", {
          :user_id => User.current.id,
          :start_date => start_date.to_s,
          :end_date => end_date.to_s
        }],
      :group => "niko",
      :order => "niko ASC"
    )
    days_of_term = (end_date - start_date).to_i + 1 
    total_count = 0
    summary = {"0" => 0, "1" => 0, "2" => 0, "3" => 0}
    result.each do |tmp|
      summary[tmp.niko] = tmp.count
      total_count += tmp.count
    end
    summary["0"] += days_of_term - total_count if total_count < days_of_term
    return summary
  end
end
