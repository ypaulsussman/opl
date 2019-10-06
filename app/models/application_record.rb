# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # @TODO: originally the below was included w/ the above
  # b/c uuid's not a great default sort -- however,
  # it's already caused more problems than it appears to solve... delete?
  # default_scope { order(created_at: :asc) }
end
