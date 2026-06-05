# frozen_string_literal: true

module TasksHelper
  PRIORITY_CLASSES = {
    'high' => 'bg-red-100 text-red-700',
    'medium' => 'bg-yellow-100 text-yellow-700',
    'low' => 'bg-blue-100 text-blue-700'
  }.freeze

  BADGE_BASE = 'px-2 py-1 rounded text-xs font-medium'

  def priority_badge(task)
    content_tag(:span, t("enums.task.priority.#{task.priority}"),
                class: "#{BADGE_BASE} #{PRIORITY_CLASSES[task.priority]}")
  end

  def status_badge(task)
    color = task.complete? ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-600'
    content_tag(:span, t("enums.task.status.#{task.status}"),
                class: "#{BADGE_BASE} #{color}")
  end

  def due_date_cell(task)
    base = 'px-4 py-3'

    if task.due_date.nil?
      return content_tag(:td, '―', class: "#{base} text-gray-400")
    end

    if task.complete?
      return content_tag(:td, task.due_date, class: "#{base} text-gray-400 line-through")
    end

    classes, label = due_date_style(task)

    content_tag(:td, class: "#{base} #{classes}") do
      concat task.due_date.to_s
      concat content_tag(:span, label, class: 'ml-2 text-xs') if label
    end
  end

  private

  def due_date_style(task)
    if task.overdue?
      ['text-red-700 font-semibold', "(#{-task.days_until_due}日遅れ)"]
    elsif task.due_today?
      ['text-red-600 font-semibold', '今日']
    elsif task.due_soon?
      ['text-orange-600 font-medium', "あと#{task.days_until_due}日"]
    else
      ['text-gray-500', nil]
    end
  end
end
