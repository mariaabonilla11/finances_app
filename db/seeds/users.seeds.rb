users = [
  {
    first_name: "Webmaster",
    last_name: "User",
    email: "maria.bonilla@example.com",
    password: "securepassword",
    state: 1,
    created_by: 1,
    updated_by: 1
  },
  {
    first_name: "Testing",
    last_name: "User",
    email: "testing@example.com",
    password: "securepassword",
    state: 1,
    created_by: 1,
    updated_by: 1
  }
]

users.each do |attrs|
  user = User.find_by(email: attrs[:email])

  if user
    puts "🔁 Usuario existente: #{user.email}"
  else
    User.create!(attrs)
    puts "✅ Usuario creado: #{attrs[:email]}"
  end
end

puts "Total usuarios: #{User.count}"
