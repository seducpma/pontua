class Obreiro < ActiveRecord::Base
  has_many :relatorios
  has_many :unidades
  
end
