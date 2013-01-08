# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

#get 'nikoniko_calendar', :to => 'nikoniko_calendar#index'
match 'nikoniko_calendar', :controller => :NikonikoCalendar, :action => :index, :via => :get
