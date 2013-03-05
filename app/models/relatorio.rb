class Relatorio < ActiveRecord::Base
  belongs_to :obreiro
  belongs_to :unidade
end
