class Relatorio < ActiveRecord::Base
  belongs_to :obreiro
  belongs_to :unidade

  validates_presence_of :unidade_id, :message => ' Selecionar EMPRESA'

end
