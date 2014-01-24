module RatingAverage

	def average_rating
		if ratings.count == 0
			return 0
		end

		str = ""
 	
 		if ratings.count > 1
 			str += "Beers have " + ratings.count.to_s + " ratings"
 		else
 			str += "Beers have " + ratings.count.to_s + " rating"
 		end

 	    str += ", average "
 	    str += '%.1f' % (ratings.average 'score')
 	    
 	    return str
	end

end