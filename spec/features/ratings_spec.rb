require 'spec_helper'
include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in username:"Pekka", password:"Foobar1"
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    #expect(beer1.average_rating).to eq(15.0)
    expect(beer1.average_rating).to eq("Beers have 1 rating, average 15.0")
  end

  it "ratings and total number of them is shown on index" do
    FactoryGirl.create(:rating, user:User.first, beer:Beer.first)
    FactoryGirl.create(:rating, user:User.first, beer:Beer.last)

    visit ratings_path

    expect(page).to have_content "Number of ratings 2"
    expect(page).to have_content "iso 3 10 Pekka"
    expect(page).to have_content "Karhu 10 Pekka"
  end


    it "when signed in is shown only own ratings" do
      wrongBeer = FactoryGirl.create(:beer, name:"paha")
      wrongUser = FactoryGirl.create(:user, username:"esa")
      wrongRating = FactoryGirl.create(:rating, user:wrongUser, beer:wrongBeer)
      rating1 = FactoryGirl.create(:rating, user:user, beer:beer1)
      rating2 = FactoryGirl.create(:rating, user:user, beer:beer2)

      visit user_path(user)
      
      expect(page).to have_content(rating1)
      expect(page).to have_content(rating2)
      expect(user.ratings.count).to eq(2)
      expect(page).not_to have_content(wrongRating)
    end
end