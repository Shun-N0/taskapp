# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @categories = current_user.categories.order(:created_at)
    @current_category_id = params[:category_id].presence
    @task_counts = current_user.tasks.group(:category_id).count
    @total_count = current_user.tasks.count
    tasks = current_user.tasks.order(Arel.sql('due_date ASC NULLS LAST'), created_at: :desc)
    tasks = tasks.where(category_id: @current_category_id) if @current_category_id
    @tasks = tasks
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

