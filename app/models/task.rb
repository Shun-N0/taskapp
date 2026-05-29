# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  enum :priority, { low: 0, medium: 1, high: 2 }
  enum :status, { incomplete: 0, complete: 1 }

  validates :title, presence: true
end

