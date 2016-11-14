class ListMembership < ApplicationRecord
  belongs_to :user
  belongs_to :list
end
