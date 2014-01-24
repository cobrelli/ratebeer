class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings, :dependent => :destroy

	def to_s
		"#{name} #{brewery.name}"
	end

	def average_rating
		if ratings.count == 0
			return 0
		end

		str = "beer has "
 	
 		if ratings.count > 1
 			str += ratings.count.to_s + " ratings"
 		else
 			str += ratings.count.to_s + " rating"
 		end

 	    str += ", average "
 	    str += '%.1f' % (ratings.average 'score')
 	    
 	    return str
	end
end
