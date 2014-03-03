class Fact < ActiveRecord::Base
	validates :details, :presence => true
end
