# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  enum :priority, { low: 0, medium: 1, high: 2 }
  enum :status, { incomplete: 0, complete: 1 }

  validates :title, presence: true

  def days_until_due
    return nil if due_date.nil?

    (due_date - Date.current).to_i
  end

  def overdue?
    return false if due_date.nil? || complete?

    days_until_due.negative?
  end

  def due_today?
    return false if due_date.nil? || complete?

    days_until_due.zero?
  end

  def due_soon?
    return false if due_date.nil? || complete?

    days_until_due.between?(1, 3)
  end
end

