categories = [
  {
    name: "Comida"
  },
  {
    name: "Servicio / Hogar"
  },
  {
    name: "Deuda"
  },
  {
    name: "Ahorro"
  },
  {
    name: "Transporte"
  },
  {
    name: "Compras"
  },
  {
    name: "Entretenimiento"
  },
  {
    name: "Imprevistos"
  },
]

categories.each do |attrs|
  Category.create!(attrs)
  puts "✅ Categoria creada: #{attrs[:name]}"
end