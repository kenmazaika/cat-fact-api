require 'test_helper'

class Api::V1::FactsControllerTest < ActionController::TestCase

	setup do
		Fact.destroy_all
	end
	test "index json" do 
		fact = FactoryGirl.create(:fact)
		get :index, :format => :json
		assert_response :success

		assert_equal 1, json_resp['total_pages']
		assert_equal 1, json_resp['page']
		assert_equal 1, json_resp['facts'].count
		assert_equal fact.details, json_resp['facts'].first['details']
	end

	test "index json page 2" do 
		Fact.default_per_page.times do
			FactoryGirl.create(:fact)
		end
		fact = FactoryGirl.create(:fact, :details => 'omg haha')
		get :index, :format => :json, :page => 2
		assert_response :success

		assert_equal 2, json_resp['total_pages']
		assert_equal 2, json_resp['page']
		assert_equal 1, json_resp['facts'].count
		assert_equal fact.details, json_resp['facts'].first['details']
	end

	test 'create' do
		detail = 'omg hahaha'
		assert_difference 'Fact.count' do
			post :create, :format => :json, :fact => {:details => detail }
		end
		assert_response :success
		assert_equal detail, json_resp['details']
		assert_equal detail, Fact.last.details
	end
	
	test 'create unprocessable entity' do
		assert_no_difference 'Fact.count' do
			post :create, :format => :json, :fact => {:details => '' }
		end
		assert_response :unprocessable_entity
		assert_equal ['can\'t be blank'], json_resp['details']
	end
		


	private

	def json_resp
		ActiveSupport::JSON.decode(@response.body)
	end
end
