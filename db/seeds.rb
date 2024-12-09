# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "faker"

Enrollment.delete_all
Course.delete_all
User.delete_all

puts "DB limpias."

# Crear usuarios
User.create!(
  name: "Carlos Santana",
  email: "carlos.santana@gmail.com",
  password: "123456",
  telephone: Faker::Number.number(digits: 9),
  role: "admin"
)
admin = User.last
puts "Id del administrador creado: #{admin.id}"
admin_id = admin.id

User.create!(
  name: "Adis Camus",
  email: "adis.camus@gmail.com",
  password: "123456",
  telephone: Faker::Number.number(digits: 9),
  role: "normal"
)

10.times do
  User.create!(
    name: Faker::Name.first_name+" "+Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    password: "123456",
    telephone: Faker::Number.number(digits: 9),
    role: "normal")
end

puts "Se crearon #{User.count} usuarios."

# Crear cursos
50.times do
  Course.create!(
    title: Faker::Educator.course_name,
    description: Faker::Lorem.sentence(word_count: 15),
    duration: rand(5..60),
    user_id: admin_id # Los cursos los crea el usuario administrador
  )
end

puts "Se crearon #{Course.count} cursos."

users = User.where(role: "normal")
courses = Course.all
# courses.sample(rand(1..5)).each do |course| # Selecciona entre 1 y 5 cursos aleatorios

users.each do |user|
  # courses.sample(rand(1..5)).each do |course| # Selecciona entre 1 y 5 cursos aleatorios
  courses.sample(5).each do |course| # Selecciona entre 5 cursos aleatorios
    progreso = rand(0..course.duration) # Usa duración válida
    puts "Inscribiendo usuario #{user.id} al curso #{course.id} con progreso #{progreso}"
    Enrollment.create!(
      user: user,          # Usa la instancia del usuario
      course: course,      # Usa la instancia del curso
      progress: progreso   # Progreso aleatorio
    )
  end
end

puts "Se crearon #{Enrollment.count} inscripciones."
