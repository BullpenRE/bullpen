# require 'rails_helper'
#
# describe Test::DatabasesController do
#   describe '/clean_database' do
#     it 'truncates and seeds the database' do
#       5.times { |i| create( :user) }
#
#       post :clean_database, params: { 'database': { 'should_seed': true } }
#
#       # Seed db/seeds/test for default seeds
#       expect(User.count).to eq 2
#     end
#
#     it 'truncates and seeds the database' do
#       5.times { |i| create(:user) }
#
#       post :clean_database, params: { 'database': { 'should_seed': false } }
#
#       expect(User.count).to eq 0
#     end
#   end
# end
