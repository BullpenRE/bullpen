require 'rails_helper'

RSpec.describe BubbleExtractData do
  let(:service) { BubbleExtractData.new('sometype') }

  it 'instantiates OK' do
    expect(service).to be_present
  end
end
