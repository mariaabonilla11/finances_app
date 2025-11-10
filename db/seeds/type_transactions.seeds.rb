type_transactions = [
  {
    name: "Ingreso"
  },
  {
    name: "Gasto"
  }
]

type_transactions.each do |attrs|
  TypeTransaction.create!(attrs)
  puts "✅ Tipo de transaccion creado: #{attrs[:name]}"
end