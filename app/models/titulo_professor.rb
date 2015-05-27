class TituloProfessor < ActiveRecord::Base
  belongs_to :titulo
  belongs_to :professor
end
