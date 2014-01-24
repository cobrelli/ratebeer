class Brewery < ActiveRecord::Base
	has_many :beers, :dependent => :destroy
	has_many :ratings, :through => :beers

	def average_rating
		if ratings.count == 0
			return 0
		end

		str = "Brewery has "
 	
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
