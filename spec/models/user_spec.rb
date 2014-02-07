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
end