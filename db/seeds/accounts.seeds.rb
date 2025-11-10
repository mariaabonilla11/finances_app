accounts = [
  {
    name: "Efectivo",
    balance: 10000,
    currency: "COP"
  }
]

accounts.each do |attrs|
  Account.create!(attrs)
  puts "✅ Cuenta creada: #{attrs[:name]}"
end