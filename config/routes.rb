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
match 'nikoniko_calendar', :controller => :nikoniko_calendar, :action => :index, :via => :get, :as => "nikoniko_calendar"
match 'nikoniko_calendar/history(/:year/:month)', :controller => :nikoniko_calendar, :action => :history, :via => :get, :constraints => {:year => /[0-9]{4}/, :month => /[0-9]{1,2}/}, :as => "nikoniko_calendar_history"
match 'nikoniko_calendar/post', :controller => :nikoniko_calendar, :action => :post, :via => :post, :as => "nikoniko_calendar_post"

match '/projects/:project_id/nikoniko_calendar', :controller => :nikoniko_calendar_project, :action => :index, :via => :get, :as => "nikoniko_calendar_project" 
