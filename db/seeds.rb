# frozen_string_literal: true

require 'csv'

authors = CSV.read(Rails.root.join('db', 'opl_authors_seed.csv'), headers: true)
authors.each do |row|
  author = row['Author']
  Author.create!(name: author)
end

quotes = CSV.read(Rails.root.join('db', 'opl_quotes_seed.csv'), headers: true)
quotes.each do |row|
  author = row['Author']
  a = Author.find_by(name: author)
  Quote.create!(passage: row['Quote'], author: a)
end

User.create!(
  name: 'readonly peasant',
  email: 'user@example.com',
  password: 'foobar',
  password_confirmation: 'foobar',
  activated: true,
  activated_at: Time.zone.now
)
