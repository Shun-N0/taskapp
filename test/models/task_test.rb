# frozen_string_literal: true

require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email: 'test@example.com', password: 'password')
  end

  test 'タイトルがなければ無効' do
    task = Task.new(title: '', user: @user)
    assert task.invalid?
  end
end

