require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '#select_months_array' do
    let(:expected_output) do
      [
        ['January', 1],
        ['February', 2],
        ['March', 3],
        ['April', 4],
        ['May', 5],
        ['June', 6],
        ['July', 7],
        ['August', 8],
        ['September', 9],
        ['October', 10],
        ['November', 11],
        ['December', 12]
      ]
    end

    it 'returns an array of months with their corresponding numbers' do
      expect(helper.select_months_array).to eq(expected_output)
    end
  end
end
