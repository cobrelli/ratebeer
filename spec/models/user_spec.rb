require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq("Beers have 2 ratings, average 15.0")
    end
  end

  describe "with too short password" do
  	let(:user){ User.create username:"Pekka", password:"Se1", password_confirmation:"Se1" }

  	it "is not saved" do
  		expect(user).not_to be_valid
  		expect(User.count).to eq(0)
  	end
  end

  describe "with password with only chars" do
  	let(:user){ User.create username:"Pekka", password:"Secrettt", password_confirmation:"Secrettt" }

  	it "is not saved" do
  		expect(user).not_to be_valid
  		expect(User.count).to eq(0)
  	end
  end

  describe "favorite brewery" do
	let(:user){FactoryGirl.create(:user)}

  	it "had method for determining one" do
  		user.should respond_to :favorite_brewery
  	end

  	it "without ratings does not have one" do
  		expect(user.favorite_brewery).to eq(nil)
  	end
	
	it "is the only rated if only one rating" do
  		beer = FactoryGirl.create(:beer)
  		FactoryGirl.create(:rating, beer:beer, user:user)

  		expect(user.favorite_brewery).to eq(beer.brewery.name)
	end 

	it "with multiple ratings returns right brewery" do
		stout = FactoryGirl.create(:style, name:"Stout")
    lager = FactoryGirl.create(:style, name:"Lager")
    brewery1 = FactoryGirl.create(:brewery, name:"eka")
		brewery2 = FactoryGirl.create(:brewery, name:"toka")

		beer1 = FactoryGirl.create(:beer, name:"Laakeri", style:lager, brewery:brewery1)
		beer2 = FactoryGirl.create(:beer, name:"Stoutti", style:stout, brewery:brewery1)
		beer3 = FactoryGirl.create(:beer, name:"Laaker1", style:lager, brewery:brewery2)

		FactoryGirl.create(:rating, beer:beer1, score:10, user:user)
		FactoryGirl.create(:rating, beer:beer2, score:15, user:user)
		FactoryGirl.create(:rating, beer:beer3, score:30, user:user)

		expect(user.favorite_brewery).to eq(brewery2.name)
	end
  end

  describe "favorite style" do
  	let(:user){FactoryGirl.create(:user)}

  	it "has method for determining one" do
  		user.should respond_to :favorite_style
  	end

  	it "without ratings does not have one" do
  		expect(user.favorite_style).to eq(nil)
  	end

  	it "is the only rated if only one rating" do
      lagertest = FactoryGirl.create(:style, name:"Lagertest")

  		beer = FactoryGirl.create(:beer, style:lagertest)
  		FactoryGirl.create(:rating, beer:beer, user:user)

  		expect(user.favorite_style).to eq(beer.style.name)
	end  	

	it "with multiple ratings returns right style" do
		stout = FactoryGirl.create(:style, name:"Stout")
    lager = FactoryGirl.create(:style, name:"Lager")
    beer1 = FactoryGirl.create(:beer, name:lager, style:lager)
		beer2 = FactoryGirl.create(:beer, name:stout, style:stout)
		beer3 = FactoryGirl.create(:beer, name:lager, style:lager)

		FactoryGirl.create(:rating, beer:beer1, score:10, user:user)
		FactoryGirl.create(:rating, beer:beer2, score:15, user:user)
		FactoryGirl.create(:rating, beer:beer3, score:30, user:user)

		expect(user.favorite_style).to eq("Lager")
	end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user)}

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

end # describe User 

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating score, user
  end
end

def create_beer_with_rating(score,  user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score,  beer:beer, user:user)
  beer
end