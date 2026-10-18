# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :recoverable（パスワード再設定）はメール送信基盤が未整備のため一旦外している
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  has_many :categories, dependent: :destroy
  has_many :tasks, dependent: :destroy
end

