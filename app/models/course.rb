class Course < ApplicationRecord
  belongs_to :user
  has_many   :enrollments, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :duration, numericality: { greater_than: 0 }
end
