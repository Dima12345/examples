# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id             :bigint           not null, primary key
#  author_type    :string           not null
#  comments_count :integer          default(0), not null
#  likes_count    :integer          default(0), not null
#  parent_type    :string           not null
#  shares_count   :integer          default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#  author_id      :bigint           not null
#  parent_id      :bigint           not null
#
# Indexes
#
#  index_events_on_author                     (author_type,author_id)
#  index_events_on_parent_type_and_parent_id  (parent_type,parent_id)
#
class Event < ApplicationRecord
  AUTHOR_TYPES = [
    ::User.name,
    ::EventAuthor.name
  ].freeze

  PARENT_TYPES = [
    ::Post.name,
    ::Streak.name,
    ::Reaction.name,
    ::SurpriseGame.name,
    ::SurpriseDay.name,
    ::GlobalPost.name,
    ::HeroLevelChange.name,
    ::UserImpactAreaChange.name,
    ::ProMissionCompletionRequest.name,
    ::Shoutout.name,
    ::TeamMission.name,
    ::Report.name
  ].freeze

  belongs_to :author, polymorphic: true
  belongs_to :parent, polymorphic: true

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :hashtags_events, dependent: :destroy
  has_many :hashtags, through: :hashtags_events
  has_many :views, dependent: :destroy
  has_many :social_shares, as: :parent, dependent: :destroy
end
