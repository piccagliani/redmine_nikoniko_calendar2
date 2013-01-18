# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match 'nikoniko_calendar', :controller => :nikoniko_calendar, :action => :index, :via => :get, :as => "nikoniko_calendar"
match 'nikoniko_calendar/history(/:year/:month)', :controller => :nikoniko_calendar, :action => :history, :via => :get, :constraints => {:year => /[0-9]{4}/, :month => /[0-9]{1,2}/}, :as => "nikoniko_calendar_history"
match 'nikoniko_calendar/post', :controller => :nikoniko_calendar, :action => :post, :via => :post, :as => "nikoniko_calendar_post"

match '/projects/:project_id/nikoniko_calendar', :controller => :nikoniko_calendar_project, :action => :index, :via => :get, :as => "nikoniko_calendar_project" 
