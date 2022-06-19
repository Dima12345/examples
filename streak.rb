# frozen_string_literal: true

# == Schema Information
#
# Table name: streaks
#
#  id              :bigint           not null, primary key
#  amount          :integer          default(0), not null
#  collected_at    :datetime
#  expire_at       :datetime
#  image_url       :string
#  max_amount      :integer
#  merchant        :string
#  name            :string
#  parts_amount    :integer          default(1)
#  revealed_amount :integer          default(0), not null
#  status          :string           default("initialized"), not null
#  tier_number     :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  prize_id        :bigint           not null
#  sender_id       :bigint
#  tier_id         :bigint
#  user_id         :bigint           not null
#
# Indexes
#
#  index_streaks_on_prize_id  (prize_id)
#  index_streaks_on_status    (status)
#  index_streaks_on_tier_id   (tier_id)
#  index_streaks_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (prize_id => prizes.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
class Streak < ApplicationRecord
  extend StringEnumerable

  STATUSES = [
    INITIALIZED = 'initialized',
    ACTIVE = 'active',
    COLLECTED = 'collected',
    USED = 'used'
  ].freeze

  belongs_to :prize
  belongs_to :user
  belongs_to :tier, optional: true
  belongs_to :sender, class_name: ::User.name, optional: true

  has_one :prize_instance
  has_one :sticker, through: :prize
  has_one :reaction, as: :parent
  has_one :event, as: :parent, dependent: :destroy

  has_and_belongs_to_many :alternative_prizes, class_name: Prize.name, join_table: :alternative_prizes_streaks

  has_many :eggs, as: :result

  has_many :streaks_eggs, dependent: :destroy
  has_many :streak_eggs, through: :streaks_eggs, source: :egg

  has_many :revealed_eggs, -> { revealed }, class_name: Egg.name
  has_many :standard_missions, through: :eggs, source: :source, source_type: StandardMission.name
  has_many :social_shares, as: :parent, dependent: :destroy
  has_many :swap_reason_answers, dependent: :destroy

  string_enum status: STATUSES

  scope :by_user, ->(user) { where(user: user) }
  scope :by_prize, ->(prize) { where(prize: prize) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_sender, ->(sender) { where(sender: sender) }

  scope :collected_or_used, -> { where(status: [COLLECTED, USED]) }
  scope :not_initialized, -> { where.not(status: INITIALIZED) }
end
