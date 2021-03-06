class Task < ApplicationRecord
  validates :name, presence: true

  enum status: [task_status_enum(:pending), task_status_enum(:in_progress), task_status_enum(:done) ]
  enum priority: [task_priority_enum(:low), task_priority_enum(:medium), task_priority_enum(:high) ]

  paginates_per 30

  has_many :taggings
  has_many :tags, through: :taggings

  belongs_to :user

  def tag_items
    tags.map(&:name)
  end

  def tag_items=(names)
    self.tags = names.map{|item|
      Tag.where(name: item.strip).first_or_create! unless item.blank?}
  end

end
