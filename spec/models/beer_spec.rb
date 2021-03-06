require 'spec_helper'

describe Beer do
  
	describe "with set name and style" do
		let(:style){ Style.create name:"Lager", description:"test" }
		let(:beer){ Beer.create name:"Karhu III", style:style }

		it "is saved" do
			expect(beer).to be_valid
  			expect(Beer.count).to eq(1)
		end
	end

	describe "with name not set" do
		let(:style){ Style.create name:"Lager", description:"test" }
		let(:beer){ Beer.create style:style }

		it "is not saved" do
			expect(beer).not_to be_valid
  			expect(Beer.count).to eq(0)
		end
	end

	describe "with style not set" do
		let(:beer){ Beer.create name:"Esa" }

		it "is not saved" do
			expect(beer).not_to be_valid
  			expect(Beer.count).to eq(0)
		end
	end
end
