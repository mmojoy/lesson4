class User < ApplicationRecord
  include Gravtastic
  gravtastic
  
  EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  has_secure_password

  has_many :lists, dependent: :destroy
  has_and_belongs_to_many :shared_lists, class_name: 'List', dependent: :destroy
  has_many :tasks, through: :lists, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, format: EMAIL_REGEX, uniqueness: true
  validates :password, length: { minimum: 8 }, on: :create

  after_create :create_default_list, :check_pending_lists

  private

  def create_default_list
    lists.create(title: :default)
  end

  def check_pending_lists
    List.by_pending_email(email).each do |list|
      list.users << self
    end
  end
end
