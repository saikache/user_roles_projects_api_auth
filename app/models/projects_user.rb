class ProjectsUser < ApplicationRecord
# Just to see how many records we have in db!!!
  has_many :users
  belongs_to :project
end
