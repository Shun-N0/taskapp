class Category < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :color, presence: true
end
