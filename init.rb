Redmine::Plugin.register :redmine_nikoniko_calendar2 do
  name 'Redmine Niko-niko Calendar2 plugin'
  author 'gliani'
  description 'Niko-niko Calendar plugin for Redmine 2.X'
  version '0.0.1'
  url 'https://github.com/gliani/redmine_nikoniko_calendar2'

  menu :account_menu, :nikoniko_calendar, { :controller => 'nikoniko_calendar', :action => 'index' }, :caption => :nikoniko_calendar, :after => :my_account

  permission :nikoniko_calendar_project, { :nikoniko_calendar_project => [:index] }, :public => true
  menu :project_menu, :nikoniko_calendar_project, { :controller => 'nikoniko_calendar_project', :action => 'index' }, :caption => :nikoniko_calendar, :param => :project_id
end