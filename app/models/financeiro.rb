class Financeiro < ActiveRecord::Base
  belongs_to :unidade
  before_update :calcula_horasup
  before_save :calcula_horas
  usar_como_dinheiro :credito, :debito,:vhora, :vkm
  

def  calcula_horas
      t= self.horas
    t1= self.horarios
    t2= self.horarioe

  self.horas = (self.horarios - self.horarioe)/3600

end

def  calcula_horasup

  if (self.credito!= 0.00 or self.km!= 0.00)
    self.horas = 0.00
  else
    self.horas= 0
    self.horas = (self.horarios - self.horarioe)/3600


  end
end

  def self.convert_to_hour(minutos)
    if minutos > 60
      horas = minutos / 60
      if (minutos % 60) < 10
        horas = "#{horas}h:0#{minutos % 60} minutos"
      else
        horas = "#{horas}h:#{minutos % 60} minutos"
      end
    else
      "#{minutos} minutos"
    end
  end


end
