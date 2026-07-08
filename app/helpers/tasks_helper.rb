# frozen_string_literal: true

module TasksHelper
  PRIORITY_CLASSES = {
    'high' => 'bg-red-100 text-red-700',
    'medium' => 'bg-yellow-100 text-yellow-700',
    'low' => 'bg-blue-100 text-blue-700'
  }.freeze

  BADGE_BASE = 'inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold'

  WDAYS_JA = %w[日 月 火 水 木 金 土].freeze

  def priority_badge(task)
    content_tag(:span, "優先度：#{t("enums.task.priority.#{task.priority}")}",
                class: "#{BADGE_BASE} #{PRIORITY_CLASSES[task.priority]}")
  end

  def status_badge(task)
    color = task.complete? ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-600'
    content_tag(:span, t("enums.task.status.#{task.status}"),
                class: "#{BADGE_BASE} #{color}")
  end

  def category_chip(task)
    return if task.category.nil?

    content_tag(:span, class: "#{BADGE_BASE} gap-1.5 bg-gray-100 text-gray-600") do
      concat content_tag(:span, '', class: 'w-2 h-2 rounded-full shrink-0',
                                    style: "background-color: #{task.category.color};")
      concat task.category.name
    end
  end

  def due_date_chip(task)
    if task.due_date.nil?
      return content_tag(:span, '期日なし', class: "#{BADGE_BASE} bg-gray-50 text-gray-400")
    end

    date = task.due_date.strftime('%-m/%-d')

    label, color =
      if task.complete?
        [date, 'bg-gray-100 text-gray-400 line-through']
      elsif task.overdue?
        ["#{date} ・ #{-task.days_until_due}日遅れ", 'bg-red-100 text-red-700']
      elsif task.due_today?
        ['今日まで', 'bg-red-100 text-red-700']
      elsif task.due_soon?
        ["#{date} ・ あと#{task.days_until_due}日", 'bg-orange-100 text-orange-700']
      else
        [date, 'bg-gray-100 text-gray-600']
      end

    content_tag(:span, label, class: "#{BADGE_BASE} #{color}")
  end

  def today_heading
    today = Date.current
    "#{today.month}月#{today.day}日（#{WDAYS_JA[today.wday]}）"
  end
end
