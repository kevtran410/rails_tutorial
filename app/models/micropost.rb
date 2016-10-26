class Micropost < ApplicationRecord
  belongs_to :user

  scope :new_feeds, ->(following_ids, user_id){
    where("user_id IN (?) OR user_id = ?", following_ids, user_id)}
  scope :order_by_descending, ->{order created_at: :desc}

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, "should be less than 5MB"
    end
  end
end
