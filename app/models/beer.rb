class Beer < ActiveRecord::Base
	include RatingAverage

	belongs_to :brewery
	has_many :ratings, :dependent => :destroy

	#validates :name, presence => true
	validates :name, presence: true
	def to_s
		"#{name} #{brewery.name}"
	end
end
