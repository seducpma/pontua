class Obreiro < ActiveRecord::Base
  has_many :relatorios
  has_many :unidades
   has_many :users
  
end
