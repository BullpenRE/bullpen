require 'rails_helper'

describe ApplicationFlowsHelper, type: :helper do
  describe '#cleaned_per_hour_bid' do
    it 'checks results' do
      expect(helper.cleaned_per_hour_bid('$43,334')).to eq(43)
      expect(helper.cleaned_per_hour_bid('$43334')).to eq(43334)
      expect(helper.cleaned_per_hour_bid('43334')).to eq(43334)
      expect(helper.cleaned_per_hour_bid('433.34')).to eq(433)
      expect(helper.cleaned_per_hour_bid('4333.4')).to eq(4333)
      expect(helper.cleaned_per_hour_bid('4.3334')).to eq(4)
      expect(helper.cleaned_per_hour_bid('wefwef4333.4')).to eq(0)
      expect(helper.cleaned_per_hour_bid('wefwefwef')).to eq(0)
    end
  end
end