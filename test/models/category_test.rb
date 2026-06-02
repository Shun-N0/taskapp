# frozen_string_literal: true

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email: 'test@example.com', password: 'password')
  end

  test '名前がなければ無効' do
    category = Category.new(name: '', color: '#FF0000', user: @user)
    assert category.invalid?
  end

  test '色がなければ無効' do
    category = Category.new(name: '仕事', color: '', user: @user)
    assert category.invalid?
  end

  test '同じユーザーで同じ名前は無効' do
    Category.create!(name: '仕事', color: '#FF0000', user: @user)
    category = Category.new(name: '仕事', color: '#0000FF', user: @user)
    assert category.invalid?
  end

  test '別のユーザーなら同じ名前でも有効' do
    other_user = User.create!(email: 'other@example.com', password: 'password')
    Category.create!(name: '仕事', color: '#FF0000', user: @user)
    category = Category.new(name: '仕事', color: '#0000FF', user: other_user)
    assert category.valid?
  end
end

