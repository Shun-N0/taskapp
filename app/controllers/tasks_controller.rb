# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = current_user.tasks.order(created_at: :desc)
  end

  def show; end

  def new
    @task = current_user.tasks.build
  end

  def edit; end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'タスクを作成しました'
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'タスクを更新しました'
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'タスクを削除しました'
  end

  private

  def set_task
    @task = current_user.tasks.find(params.expect(:id))
  end

  def task_params
    params.expect(task: %i[title description due_date priority status category_id])
  end
end

