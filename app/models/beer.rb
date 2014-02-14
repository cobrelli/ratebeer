class Beer < ActiveRecord::Base
	include RatingAverage

	belongs_to :style
	belongs_to :brewery
	has_many :ratings, :dependent => :destroy
	has_many :raters, -> { uniq }, through: :ratings, source: :user, :dependent => :destroy
	
	#validates :name, presence => true
	validates :name, presence: true
	#validates :style, presence: true
	validates_presence_of :style

	def to_s
		"#{name} #{brewery.name}"
	end
end
