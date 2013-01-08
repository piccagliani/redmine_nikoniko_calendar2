Redmine::Plugin.register :redmine_nikoniko_calendar2 do
  name 'Redmine Niko-niko Calendar2 plugin'
  author 'gliani'
  description 'Niko-niko Calendar plugin for Redmine 2.X'
  version '0.0.1'
  url 'https://github.com/gliani/redmine_nikoniko_calendar2'

  menu :application_menu, :nikoniko_calendar, { :controller => 'NikonikoCalendar', :action => 'index' }, :caption => :nikoniko_calendar
end