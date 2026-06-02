# frozen_string_literal: true

require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: 'test@example.com', password: 'password')
    @other_user = User.create!(email: 'other@example.com', password: 'password')
    @task = Task.create!(title: 'テストタスク', user: @user)
  end

  test '未ログインでindexにアクセスするとログイン画面にリダイレクト' do
    get tasks_path
    assert_redirected_to new_user_session_path
  end

  test 'ログイン済みでindexにアクセスできる' do
    sign_in @user
    get tasks_path
    assert_response :success
  end

  test 'タスクを作成できる' do
    sign_in @user
    assert_difference('Task.count') do
      post tasks_path, params: { task: { title: '新しいタスク', priority: :low, status: :incomplete } }
    end
    assert_redirected_to tasks_path
  end

  test 'タイトルなしでタスクを作成できない' do
    sign_in @user
    assert_no_difference('Task.count') do
      post tasks_path, params: { task: { title: '' } }
    end
    assert_response :unprocessable_entity
  end

  test 'タスクを更新できる' do
    sign_in @user
    patch task_path(@task), params: { task: { title: '更新後タイトル' } }
    assert_redirected_to tasks_path
    assert_equal '更新後タイトル', @task.reload.title
  end

  test 'タスクを削除できる' do
    sign_in @user
    assert_difference('Task.count', -1) do
      delete task_path(@task)
    end
    assert_redirected_to tasks_path
  end

  test '他のユーザーのタスクにアクセスできない' do
    sign_in @other_user
    get task_path(@task)
    assert_response :not_found
  end
end

