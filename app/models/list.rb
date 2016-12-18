class List < ApplicationRecord
  has_many :tasks, dependent: :delete_all
  has_many :pending_emails, dependent: :delete_all
  has_and_belongs_to_many :users
  belongs_to :user

  validates :title, presence: true,
                    length: { minimum: 3 },
                    uniqueness: true

  scope :for, lambda { |user|
    joins('LEFT JOIN lists_users ON lists.id = lists_users.list_id')
      .where('lists_users.user_id = :user OR lists.user_id = :user', user: user)
  }

  scope :by_pending_email, (lambda do |email|
    joins(:pending_emails)
      .where('pending_emails.email = ?', email)
  end)

  def all_users
    [user] + users
  end
end
