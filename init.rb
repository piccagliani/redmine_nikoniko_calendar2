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

Redmine::Plugin.register :redmine_nikoniko_calendar2 do
  name 'Redmine Niko-niko Calendar2 plugin'
  author 'piccagliani'
  description 'Niko-niko Calendar plugin for Redmine 2.X'
  version '0.1.0'
  url 'https://github.com/piccagliani/redmine_nikoniko_calendar2'

  menu :account_menu, :nikoniko_calendar, { :controller => 'nikoniko_calendar', :action => 'index' }, :caption => :nikoniko_calendar, :after => :my_account

  permission :nikoniko_calendar_project, { :nikoniko_calendar_project => [:index] }, :public => true
  menu :project_menu, :nikoniko_calendar_project, { :controller => 'nikoniko_calendar_project', :action => 'index' }, :caption => :nikoniko_calendar, :param => :project_id
end