# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "rails/all"
User.destroy_all
BookCategory.destroy_all
Book.destroy_all
Author.destroy_all
BookView.destroy_all
Category.destroy_all

User.create(email: "stevennguyen@motorist.com", password: "123Steven", confirmation_password: "123Steven", username: "stevennguyen", first_name: "steven", last_name: "nguyen", role: RoleConst::ADMIN)
User.create(email: "locnguyen01@gmail.com", password: "123Steven", confirmation_password: "123Steven", username: "locnguyen01", first_name: "alex", last_name: "vinh", role: RoleConst::USER)
User.create(email: "locnguyen02@gmail.com", password: "123Steven", confirmation_password: "123Steven", username: "locnguyen02", first_name: "erik", last_name: "cao", role: RoleConst::USER)
User.create(email: "locnguyen03@gmail.com", password: "123Steven", confirmation_password: "123Steven", username: "locnguyen03", first_name: "johny", last_name: "pham", role: RoleConst::USER)
User.create(email: "locnguyen04@gmail.com", password: "123Steven", confirmation_password: "123Steven", username: "locnguyen04", first_name: "tony", last_name: "han", role: RoleConst::USER)
User.create(email: "locnguyen05@gmail.com", password: "123Steven", confirmation_password: "123Steven", username: "locnguyen05", first_name: "niko", last_name: "teo", role: RoleConst::USER)
User.create(email: "locnguyen06@gmail.com", password: "123Steven", confirmation_password: "123Steven", username: "locnguyen06", first_name: "tony", last_name: "nguyen", role: RoleConst::USER)


100.times do |i|
  # Spread users randomly across the last 6 months
  random_date = rand(6.months.ago..Time.current)

  user = User.new(
    email: Faker::Internet.unique.email,
    password: "123Steven",
    confirmation_password: "123Steven",
    username: Faker::Internet.unique.username(specifier: 5..10),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: RoleConst::USER,
    created_at: random_date
  )

  user.save!
  # user.update_column(:created_at, random_date)
end

timestamp = Time.current

category_names = [
  'Science Fiction', 'Fantasy', 'Mystery', 'Non-Fiction',
  'Biography', 'History', 'Romance', 'Thriller', 'Self-Help'
]

categories_data = category_names.map do |name|
  {
    name: name,
    slug: name.parameterize,
    description: Faker::Lorem.sentence(word_count: 10),
    created_at: timestamp,
    updated_at: timestamp
  }
end

Category.insert_all(categories_data)
category_ids = Category.pluck(:id)

authors_data = Array.new(20) do
  {
    name: Faker::Book.author,
    bio: Faker::Lorem.paragraph(sentence_count: 3),
    birth_date: Faker::Date.birthday(min_age: 25, max_age: 85),
    nationality: Faker::Nation.nationality,
    created_at: timestamp,
    updated_at: timestamp
  }
end

Author.insert_all(authors_data)
author_ids = Author.pluck(:id)

statuses = %w[public deleted private]
languages = %w[English Spanish French German Japanese]

books_data = Array.new(1000) do
  random_date = rand(6.months.ago..Time.current)
  {
    author_id: author_ids.sample,
    title: Faker::Book.title,
    code: "#{Faker::Alphanumeric.alphanumeric(number: 8).upcase}",
    description: Faker::Lorem.paragraph(sentence_count: 4),
    language: languages.sample,
    pages: rand(100..900),
    published_date: Faker::Date.between(from: 20.years.ago, to: Date.today),
    status: statuses.sample,
    cover_url: Faker::LoremFlickr.image(size: "300x400"),
    created_at: random_date,
    updated_at: random_date
  }
end

Book.insert_all(books_data)
book_ids = Book.pluck(:id)

book_categories_data = []

book_ids.each do |b_id|
  assigned_categories = category_ids.sample(rand(1..3))
  assigned_categories.each do |c_id|
    book_categories_data << {
      book_id: b_id,
      category_id: c_id,
      created_at: timestamp,
      updated_at: timestamp
    }
  end
end

BookCategory.insert_all(book_categories_data)

book_views_data = Array.new(250) do
  random_date = rand(6.months.ago..Time.current)
  {
    book_id: book_ids.sample,
    user_id: rand(1..50),
    created_at: random_date,
    updated_at: random_date
  }
end

BookView.insert_all(book_views_data)
