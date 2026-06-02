# frozen_string_literal: true

require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: 'test@example.com', password: 'password')
    @other_user = User.create!(email: 'other@example.com', password: 'password')
    @category = Category.create!(name: 'テストカテゴリ', color: '#FF0000', user: @user)
  end

  test '未ログインでindexにアクセスするとログイン画面にリダイレクト' do
    get categories_path
    assert_redirected_to new_user_session_path
  end

  test 'ログイン済みでindexにアクセスできる' do
    sign_in @user
    get categories_path
    assert_response :success
  end

  test 'カテゴリを作成できる' do
    sign_in @user
    assert_difference('Category.count') do
      post categories_path, params: { category: { name: '新しいカテゴリ', color: '#0000FF' } }
    end
    assert_redirected_to categories_path
  end

  test '名前なしでカテゴリを作成できない' do
    sign_in @user
    assert_no_difference('Category.count') do
      post categories_path, params: { category: { name: '', color: '#FF0000' } }
    end
    assert_response :unprocessable_entity
  end

  test 'カテゴリを更新できる' do
    sign_in @user
    patch category_path(@category), params: { category: { name: '更新後カテゴリ' } }
    assert_redirected_to categories_path
    assert_equal '更新後カテゴリ', @category.reload.name
  end

  test 'カテゴリを削除できる' do
    sign_in @user
    assert_difference('Category.count', -1) do
      delete category_path(@category)
    end
    assert_redirected_to categories_path
  end

  test '他のユーザーのカテゴリにアクセスできない' do
    sign_in @other_user
    get category_path(@category)
    assert_response :not_found
  end
end

