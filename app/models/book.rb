class Book < ApplicationRecord
  belongs_to :user
  has_one_attached :thumbnail
  has_many :libraries
  has_many :added_books, through: :libraries, source: :user
end
