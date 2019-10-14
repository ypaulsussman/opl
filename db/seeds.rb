# frozen_string_literal: true

# This file should contain all the record creation needed
# to seed the database with its default values.
# The data can then be loaded with the rails db:seed command
# (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

authors = CSV.read(Rails.root.join('db', 'opl_authors_seed.csv'), headers: true)
authors.each do |row|
  author = row['Author']
  Author.create!(name: author)
  puts "Added #{author}..."
end

quotes = CSV.read(Rails.root.join('db', 'opl_quotes_seed.csv'), headers: true)
quotes.each do |row|
  author = row['Author']
  a = Author.find_by(name: author)
  Quote.create!(passage: row['Quote'], author: a)
  puts "Added quote by #{author}..."
end
