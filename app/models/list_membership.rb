class ListMembership < ApplicationRecord
  enum role: {owner: 10, moderator: 20, contributor: 30, subscriber: 40 }

  validates_uniqueness_of :role,
    if: ->{role == "owner"},
    scope: :list,
    message: "must be transferred with current list owner's permission"

  belongs_to :user
  belongs_to :list

  def permissions
    case role
    when 'owner'        then ['read','write','moderate','delete']
    when 'moderator'    then ['read','write','moderate']
    when 'contributor'  then ['read','write']
    when 'subscriber'   then ['read']
    end
  end
end
