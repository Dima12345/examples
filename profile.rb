# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id                           :bigint           not null, primary key
#  active                       :boolean          default(TRUE), not null
#  address                      :string
#  address_line_2               :string
#  bio                          :text             default(""), not null
#  birth_date                   :datetime
#  bitmoji_data                 :jsonb
#  city                         :string
#  company_name                 :string
#  correct_answers_count        :integer          default(0), not null
#  country                      :string
#  country_code                 :string
#  department                   :string
#  experience_level             :integer          default(1), not null
#  flow                         :string           default("fun"), not null
#  friends_count                :integer          default(0), not null
#  gender                       :string
#  goal                         :string           default("improve_stature"), not null
#  image_data                   :jsonb
#  incorrect_answers_count      :integer          default(0), not null
#  industry                     :string
#  job_title                    :string
#  latitude                     :decimal(, )
#  level                        :integer          default(1), not null
#  longitude                    :decimal(, )
#  member_since                 :datetime
#  mode                         :string           default("demo"), not null
#  monthly_rainbow_eggs_limit   :integer          default(100), not null
#  postal_code                  :string
#  private                      :boolean          default(FALSE), not null
#  purchased_rainbow_eggs_count :integer          default(0), not null
#  role                         :string           default("employee"), not null
#  start_date                   :datetime
#  state                        :string
#  state_code                   :string
#  timezone                     :string           default("America/New_York")
#  title                        :string           default(""), not null
#  total_coins                  :integer          default(0), not null
#  total_experience_points      :integer          default(0), not null
#  total_hero_points            :integer          default(0), not null
#  username                     :string
#  work_place                   :string           default("remote"), not null
#  workday_ends_at              :string
#  workday_starts_at            :string
#  employee_id                  :string
#  office_id                    :bigint
#  persona_id                   :bigint
#  team_id                      :bigint
#  user_id                      :bigint           not null
#
# Indexes
#
#  index_profiles_on_gender     (gender)
#  index_profiles_on_office_id  (office_id)
#  index_profiles_on_role       (role)
#  index_profiles_on_team_id    (team_id)
#  index_profiles_on_user_id    (user_id) UNIQUE
#  index_profiles_on_username   (username) USING gin
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
class Profile < ApplicationRecord
  extend StringEnumerable

  include Geocoded.new(store: :in_db, timezone: true)
  include ImageUploader::Attachment(:image)

  GENDERS = [
    FEMALE = 'female',
    MALE = 'male',
    NON_BINARY = 'non_binary'
  ].freeze

  GOALS = [
    IMPROVE_STATURE = 'improve_stature',
    DEMAND_MORE = 'demand_more',
    STANDARD_MANAGER = 'standard_manager'
  ].freeze

  ROLES = [
    OWNER = 'owner',
    EMPLOYEE = 'employee',
    ADMIN = 'admin'
  ].freeze

  MODES = [
    DEMO = 'demo',
    LIVE = 'live'
  ].freeze

  FLOWS = [
    FUN = 'fun',
    WORK = 'work'
  ].freeze

  WORK_PLACES = [
    REMOTE = 'remote',
    OFFICE = 'office',
    MIXED = 'mixed'
  ].freeze

  DEFAULTS = [
    WORKDAY_STARTS_AT = '09:00',
    WORKDAY_ENDS_AT = '18:00'
  ].freeze

  belongs_to :user
  has_many :quizzes, through: :user
  has_many :cards, through: :quizzes
  belongs_to :persona, optional: true
  belongs_to :team, optional: true
  belongs_to :office, optional: true

  has_many :hero_points, dependent: :destroy
  has_many :experience_points, dependent: :destroy
  has_many :coin_transactions, dependent: :destroy

  has_many :daily_stats, dependent: :destroy
  has_many :app_usage_stats, dependent: :destroy

  has_one :last_experience_point, -> { order(id: :desc) }, class_name: ExperiencePoint.name

  string_enum gender: GENDERS
  string_enum goal: GOALS
  string_enum role: ROLES
  string_enum mode: MODES
  string_enum flow: FLOWS

  has_paper_trail

  scope :active, -> { where(active: true) }
  scope :with_department, -> { where.not(department: '') }
  scope :by_city, ->(city) { where(city: city) }
  scope :by_department, ->(department) { where(department: department) }
  scope :by_job_title, ->(job_title) { where(job_title: job_title) }
  scope :by_start_date, ->(time) { where(start_date: time.beginning_of_day..time.end_of_day) }
  scope :by_user, ->(user) { where(user: user) }
  scope :with_address, -> { where.not(longitude: nil).where.not(latitude: nil) }
  scope :by_state_code, ->(state_code) { where(state_code: state_code) }
  scope :by_team, ->(team) { where(team: team) }
end
