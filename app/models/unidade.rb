class Unidade < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  has_many :relatorios
  has_many :funcionarios
  has_many :financeiros
  belongs_to :obreiro
  has_many :users

  ATIVIDADE = %w(COMÉRCIAL EDUCAÇÃO INDUSTRIAL PRESTAÇÃO_SERVIÇOS SERVIÇO_PÚBLICO OUTROS)


  def simplificada
    truncate(self.nome, :length=> 50)
  end

  def ativo
   if em_atividade == false then
    return "NÃO"
   else
      return "SIM"
   end
  end

  
end
