FactoryBot.define do
  factory :payment_account do
    employer_profile
    stripe_object { 'card' }
    id_stripe { "card_#{Faker::Crypto.md5[0..22]}" }
    last_four { 4.times.map { rand(10) }.join }
    fingerprint { Faker::Crypto.md5[0..16] }
    card_brand { ['American Express', 'Diners Club', 'Discover', 'JCB', 'MasterCard', 'UnionPay', 'Visa', 'Unknown'].sample }
    card_expires { 2.years.from_now }
    card_cvc_check { %w[pass fail unavailable unchecked].sample }

    # trait :bank do
    #   stripe_object { 'bank_account' }
    #   id_stripe { "ba_#{Faker::Crypto.md5[0..22]}" }
    #   card_brand { nil }
    #   card_expires { nil }
    #   card_cvc_check { nil }
    #   bank_name { Faker::Bank.name }
    #   bank_routing_number { Faker::Bank.routing_number }
    #   bank_status { %w[new validated verified verification_failed errored].sample }
    # end
  end
end
