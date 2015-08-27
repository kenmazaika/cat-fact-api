require 'test_helper'

class Api::V1::FactsControllerTest < ActionController::TestCase

	setup do
		Fact.destroy_all
	end
	test "index json" do 
		fact = FactoryGirl.create(:fact)
		t = Time.now.to_i
		token = Digest::SHA256.hexdigest("#{t}k1tten_m1tt3ns")
		get :index, :format => :json, :t => t, :client => 'charlie_kelly', :token => token 
		assert_response :success

		assert_equal 1, json_resp['total_pages']
		assert_equal 1, json_resp['page']
		assert_equal 1, json_resp['facts'].count
		assert_equal fact.details, json_resp['facts'].first['details']
	end

	test "index json bad timestamp" do 
		Timecop.freeze(Time.now) do
			fact = FactoryGirl.create(:fact)
			t = (Time.now - 10.minutes).to_i
			token = Digest::SHA256.hexdigest("#{t}k1tten_m1tt3ns")
			get :index, :format => :json, :t => t, :client => 'charlie_kelly', :token => token
			assert_response :forbidden
		end
	end

	test "index json don't know secret key" do 
		fact = FactoryGirl.create(:fact)
		t = Time.now.to_i
		token = Digest::SHA256.hexdigest("#{t}BAD SECRET KEY")
		get :index, :format => :json, :t => t, :client => 'charlie_kelly', :token => token
		assert_response :forbidden
	end

	private

	def json_resp
		ActiveSupport::JSON.decode(@response.body)
	end
end
