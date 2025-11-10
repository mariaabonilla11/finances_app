# API de Finanzas APP

RESTAPI para el registro de transacciones y control de finanzas construida con Ruby on Rails 7

## 🚀 Tecnologías

- **Ruby**: 3.2.2
- **Rails**: 7.1.0
- **Base de datos**: PostgreSQL
- **Comunicación**: HTTP REST (HTTParty)
- **Testing**: RSpec

## 📋 Prerequisitos

- Ruby 3.2.2
- MongoDB
- Bundler
- Docker

## ⚙️ Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/mariaabonilla11/finances-app
cd finances_app
```

### 2. Ejecutar imagen y correr contenedor 🐳

### Construir imagen

```bash
cd finances_app
docker compose up --build
```


### 3. Correr migraciones y seeders

### Conectarse al contenedor

```bash
docker exec -it finances_app-api-1 bash
rails db:migrate
rails db:seed
```

### 4. Correr Tests

### Conectarse al contenedor
```bash
docker exec -it finances_app-api-1 bash
RAILS_ENV=test bundle exec rspec
```
