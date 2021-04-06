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

  describe '#clean_currency_entry' do
    it 'checks results' do
      expect(helper.clean_currency_entry('$43,334')).to eq(43334)
      expect(helper.clean_currency_entry('$43,334,111')).to eq(43334111)
      expect(helper.clean_currency_entry('$43334')).to eq(43334)
      expect(helper.clean_currency_entry('43334')).to eq(43334)
      expect(helper.clean_currency_entry('433.34')).to eq(433)
      expect(helper.clean_currency_entry('4333.4')).to eq(4333)
      expect(helper.clean_currency_entry('4.3334')).to eq(4)
      expect(helper.clean_currency_entry('wefwef4333.4')).to eq(0)
      expect(helper.clean_currency_entry('wefwefwef')).to eq(0)
    end
  end
end
