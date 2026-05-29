# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = current_user.categories.order(created_at: :desc)
  end

  def show; end

  def new
    @category = current_user.categories.build
  end

  def edit; end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      redirect_to categories_path, notice: 'カテゴリを作成しました'
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: 'カテゴリを更新しました'
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: 'カテゴリを削除しました'
  end

  private

  def set_category
    @category = current_user.categories.find(params.expect(:id))
  end

  def category_params
    params.expect(category: %i[name color])
  end
end

