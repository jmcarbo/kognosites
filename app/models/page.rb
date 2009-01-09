class Page < ActiveRecord::Base
	acts_as_taggable
	
	attr_accessible :name, :title, :contents, :scope
	def to_param
		name
	end
end
