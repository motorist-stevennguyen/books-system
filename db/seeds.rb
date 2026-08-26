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

admin_role_id = 0
user_role_id = 0

User.create(email: "stevennguyen@motorist.com", password: "123Steven", username: "stevennguyen", role: RoleConst::ADMIN)
User.create(email: "locnguyen01@gmail.com", password: "123Steven", username: "locnguyen01", role: RoleConst::USER)


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

books_data = Array.new(50) do
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
    created_at: timestamp,
    updated_at: timestamp
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

# book_views_data = Array.new(150) do
#   {
#     book_id: book_ids.sample,
#     user_id: rand(1..50), # Assumes mock user IDs 1 to 50
#     viewed_at: Faker::Time.between(from: 6.months.ago, to: Time.current),
#     created_at: timestamp,
#     updated_at: timestamp
#   }
# end

# BookView.insert_all(book_views_data)
