FactoryBot.define do
  factory :account do
    name { "Cuenta de Ahorros" }
    balance { 10000 }
    state { :active }
    currency { "USD" }
  end
end
