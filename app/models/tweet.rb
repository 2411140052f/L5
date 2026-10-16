class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  validates :message, presence: true, length: { maximum: 280 }
end
