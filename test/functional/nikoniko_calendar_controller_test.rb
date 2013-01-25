require File.expand_path('../../test_helper', __FILE__)

class NikonikoCalendarControllerTest < ActionController::TestCase
  fixtures :users, :nikoniko_histories

  def test_index
    @request.session[:user_id] = 1
    
    get :index
    
    assert_response 200
    assert_template "index"
  end

  def test_history
    @request.session[:user_id] = 2

    # no data    
    get :history, :year => "2012", :month => "12"
    assert_response 200
    assert_template "history"
    assert_select "div#NikonikoAverageContainer span", "0.0"
    
    # data exists
    get :history, :year => "2012", :month => "11"
    assert_response 200
    assert_template "history"
    assert_select "div#NikonikoAverageContainer span", "66.7"
  end
  
  def test_post
    @request.session[:user_id] = 2
    
    today = Date.today
    comment = "This is a test"
    niko = "2"
    
    post :post, :date => today.to_s, :comment => comment, :niko => niko
    
    assert_response 200
    assert_template "post"
    
    history = NikonikoHistory.find_by_user_id_and_date(2, today.to_s)
    
    assert_not_nil history
    assert_equal comment, history.comment
    assert_equal niko, history.niko
  end
end
