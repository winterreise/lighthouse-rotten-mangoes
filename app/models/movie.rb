class Movie < ActiveRecord::Base

  scope :contains_text, ->(q) { where("lower(title) like ? or lower(director) like ?", "%#{q.downcase}%", "%#{q.downcase}%") }
  scope :less_than_90_minutes, -> { where("runtime_in_minutes <= 90") }
  scope :between_90_and_120_minutes, -> { where("runtime_in_minutes > 90 and runtime_in_minutes <= 120") }
  scope :more_than_120_minutes, -> { where("runtime_in_minutes > 120") }

  mount_uploader :poster_image_url, PosterUploader

  has_many :reviews

  validates :title,
   presence: true

  validates :director,
   presence: true

  validates :runtime_in_minutes,
   numericality: { only_integer: true }

  validates :description,
   presence: true

  validates :poster_image_url,
   presence: true

  validates :release_date,
   presence: true

  validate :release_date_is_in_the_past

  def review_average # if a movie has no reviews, reviews.size will return 0!
    if reviews.size > 0
      reviews.sum(:rating_out_of_ten)/reviews.size
    else
      0
    end
  end

  protected

  def release_date_is_in_the_past
   if release_date.present?
     errors.add(:release_date, "should be in the past") if release_date > Date.today
   end
  end

end
