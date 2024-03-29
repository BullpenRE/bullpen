require 'rails_helper'

RSpec.describe Review, type: :model do
  let!(:review) { FactoryBot.create(:review) }
  let!(:employer_profile) { review.employer_profile }
  let!(:freelancer_profile) { review.freelancer_profile }

  it 'factory works' do
    expect(review).to be_valid
  end

  context 'Validations' do
    it 'rating is between 1-5 and can be nil' do
      review.rating = nil
      expect(review).to be_valid
      review.rating = 0
      expect(review).to_not be_valid
      review.rating = 6
      expect(review).to_not be_valid
    end

    it 'cannot have the same user_id for the freelancer_profile and employer_profile' do
      employer_profile.update(user_id: freelancer_profile.user_id)
      expect(review).to_not be_valid
    end

    it 'prevents duplicate reviews' do
      duplicate_review = Review.new(freelancer_profile_id: freelancer_profile.id, employer_profile_id: employer_profile.id)
      expect(duplicate_review).to_not be_valid
    end
  end

  context 'Relationships' do
    it 'belongs to a employer_profile' do
      expect(review.employer_profile).to eq(employer_profile)
    end

    it 'belongs to a freelancer_profile' do
      expect(review.freelancer_profile).to eq(freelancer_profile)
    end
  end

  context 'Scopes' do
    let!(:review_1) { FactoryBot.create(:review, comments: nil) }
    let!(:review_2) { FactoryBot.create(:review, comments: '') }
    let!(:review_3) { FactoryBot.create(:review) }

    it '#commented' do
      expect(Review.commented).to include(review)
      expect(Review.commented).to include(review_3)
      expect(Review.commented).to_not include(review_2)
      expect(Review.commented).to_not include(review_1)
    end
  end

  context 'Methods' do
    it 'equal_rating?(review_rating)' do
      review.rating = 3
      expect(review.equal_rating?(3)).to be_truthy
      expect(review.equal_rating?(2)).to be_falsey
      expect(review.equal_rating?(nil)).to be_falsey
    end
  end
end
