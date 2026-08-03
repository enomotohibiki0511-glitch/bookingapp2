class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :checkin_at, presence: true
  validates :checkout_at, presence: true
  validates :guest_count, presence: true, numericality: { greater_than_or_equal_to: 1 }

  validate :checkin_on_or_after_today
  validate :checkout_after_checkin

  private

  def checkin_on_or_after_today
    return if checkin_at.blank?

    if checkin_at < Date.current
      errors.add(:checkin_at, "は本日以降の日付にしてください")
    end
  end

  def checkout_after_checkin
    return if checkin_at.blank? || checkout_at.blank?

    if checkout_at <= checkin_at
      errors.add(:checkout_at, "はチェックイン日より後の日付にしてください")
    end
  end
end
