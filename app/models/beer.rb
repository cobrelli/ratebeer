class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings

	def to_s
		"#{name} #{brewery.name}"
	end
end
