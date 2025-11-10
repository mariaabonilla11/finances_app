FactoryBot.define do
  factory :transaction do
    value { 123000 }
    date { "2035-11-10T14:34:15Z" }
    description { "Compras recientes" }
  end
end
