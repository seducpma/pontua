class TempoServico < ActiveRecord::Base
  validates_presence_of :professor_id, :message => ' -  PROFESSOR - PREENCHIMENTO OBRIGATÓRIO'
  has_many :relatorios
  has_many :unidades
  has_many :users
  belongs_to :professor
  before_save :salva_dados,  :pontuacao_anterior,  :total_geral,  :geral, :total_pontuacao, :atualiza_pontos_tabela_professor

 
  
   def salva_dados

    self.ano_letivo = Time.current.strftime("%Y").to_i
    self.ano1 = (Time.current.strftime("%Y").to_i)-1
    self.ano2 = Time.current.strftime("%Y").to_i
    self.dias_rede1 = self.dias1
    self.dias_rede2 = self.dias2
  
    somatoria1 = self.f_abonada1 + self.f_atestado1 + self.f_justif1 + self.f_injustif1 + self.lic_saude1 + self.afastamento1 + self.outras_aus1
    somatoria2 = self.f_abonada2 + self.f_atestado2 + self.f_justif2 + self.f_injustif2 + self.lic_saude2 + self.afastamento2 + self.outras_aus2
    somatoriaTotal = somatoria1+somatoria2
    if somatoriaTotal > 15
      self.dias_trab1 = (self.dias1 - (self.f_abonada1 + self.f_atestado1 + self.f_justif1 + self.f_injustif1 + self.lic_saude1 + self.afastamento1 + self.outras_aus1))
      self.dias_efetivos1 = (self.dias1 - (self.f_abonada1 + self.f_atestado1 + self.f_justif1 + self.f_injustif1 + self.lic_saude1 + self.afastamento1 + self.outras_aus1))
    else
      self.dias_trab1 = (self.dias1 - (self.f_justif1 + self.f_injustif1))
      self.dias_efetivos1 = (self.dias1 - (self.f_abonada1 + self.f_atestado1 + self.f_justif1 + self.f_injustif1 + self.lic_saude1 + self.afastamento1 + self.outras_aus1))
    end
     
    if somatoriaTotal > 15
      self.dias_trab2 = (self.dias2 - (self.f_abonada2 + self.f_atestado2 + self.f_justif2 + self.f_injustif2 + self.lic_saude2 + self.afastamento2 + self.outras_aus2))
      self.dias_efetivos2 = (self.dias2 - (self.f_abonada2 + self.f_atestado2 + self.f_justif2 + self.f_injustif2 + self.lic_saude2 + self.afastamento2 + self.outras_aus2))
    else
      self.dias_trab2 = (self.dias2 - (self.f_justif2 + self.f_injustif2))
      self.dias_efetivos2 = (self.dias2 - (self.f_abonada2 + self.f_atestado2 + self.f_justif2 + self.f_injustif2 + self.lic_saude2 + self.afastamento2 + self.outras_aus2))
    end

    
    self.subtot_dias = self.dias_trab1 + self.dias_trab2
    self.subtot_efetivo = self.dias_efetivos1 + self.dias_efetivos2
    self.subtot_rede = self.dias_rede1 + self.dias_rede2
    self.subtot_unid = self.dias_unidade1 + self.dias_unidade2
     

end

   
  
  
  def salva_dados_anterior

    self.ano_letivo = Time.current.strftime("%Y").to_i
    self.ano1 = (Time.current.strftime("%Y").to_i)-1
    self.ano2 = Time.current.strftime("%Y").to_i
if (Time.current.strftime("%Y").to_i)< (Time.now.year)
    self.dias_trab1 = (self.dias1 - (self.f_abonada1 + self.f_atestado1 + self.f_justif1 + self.f_injustif1 + self.lic_saude1 + self.afastamento1))
    self.dias_trab2 = (self.dias2 - (self.f_abonada2 + self.f_atestado2 + self.f_justif2 + self.f_injustif2 + self.lic_saude2 + self.afastamento2))

      if self.unidade1 == 0
        self.dias_unidade1 = 0
      else
        self.dias_unidade1 = self.unidade1 - (self.f_abonada1 + self.f_atestado1 + self.f_justif1 + self.f_injustif1 + self.lic_saude1 + self.afastamento1)
      end

    self.dias_rede1 = self.dias1 + self.outro_trab1

        if self.unidade2 == 0
          self.dias_unidade2 = 0
        else
          self.dias_unidade2 = self.unidade2 - (self.f_abonada2 + self.f_atestado2 + self.f_justif2 + self.f_injustif2 + self.lic_saude2 + self.afastamento2)
        end

    self.dias_rede2 = self.dias2 + self.outro_trab2
     
    verificando1 = ((self.f_abonada1) + (self.f_atestado1) + (self.lic_saude1) + (self.outras_aus1))
    verificando2 = ((self.f_abonada2) + (self.f_atestado2) + (self.lic_saude2) + (self.outras_aus2))
      if (verificando1  <= 15)
          self.dias_efetivos1 = self.dias1 - (self.f_justif1 + self.f_injustif1 + self.afastamento1)
      else
          self.dias_efetivos1 = self.dias1 - (self.f_abonada1 + self.f_atestado1 + self.lic_saude1 + self.f_justif1 + self.f_injustif1 + self.afastamento1 + self.outras_aus1)
      end

    verificando2 = ((self.f_abonada2) + (self.f_atestado2) + (self.lic_saude2) + (self.outras_aus2))
      if (verificando2  <= 15)
         self.dias_efetivos2 = self.dias2 - (self.f_justif2 + self.f_injustif2 + self.afastamento2)
      else
        self.dias_efetivos2 = self.dias2 - (self.f_abonada2 + self.f_atestado2 + self.lic_saude2 + self.f_justif2 + self.f_injustif2 + self.afastamento2 + self.outras_aus2)
      end

     self.subtot_dias = self.dias_trab1 + self.dias_trab2
     self.subtot_efetivo = self.dias_efetivos1 + self.dias_efetivos2
     self.subtot_rede = self.dias_rede1 + self.dias_rede2
     self.subtot_unid = self.dias_unidade1 + self.dias_unidade2
else
  #CALCULOS 2016
    if (self.f_abonada1 + self.f_atestado1 + self.f_justif1 + self.f_injustif1 + self.lic_saude1 + self.afastamento1 + self.outras_aus1)== 0
    self.dias_efetivos1 = self.dias1
  else
    t = self.dias_efetivos1
    t1 = self.dias1
    t2 = self.f_abonada1
    t3 = self.f_atestado1
    t4 = self.f_justif1
    t5 = self.f_injustif1
    t6=  self.lic_saude1
    t7 =    self.afastamento1
    self.dias_efetivos1 = (self.dias1 - (self.f_abonada1 + self.f_atestado1 + self.f_justif1 + self.f_injustif1 + self.lic_saude1 + self.afastamento1))
  end
  if (self.f_abonada2 + self.f_atestado2 + self.f_justif2 + self.f_injustif2 + self.lic_saude2 + self.afastamento1 + self.outras_aus2)== 0
   self.dias_efetivos2 = self.dias2
  else
    self.dias_efetivos2 = (self.dias2 - (self.f_abonada2 + self.f_atestado2 + self.f_justif2 + self.f_injustif2 + self.lic_saude2 + self.afastamento2))
  end

  verificando1 = ((self.f_abonada1) + (self.f_atestado1) + (self.lic_saude1) + (self.outras_aus1))
  verificando2 = ((self.f_abonada2) + (self.f_atestado2) + (self.lic_saude2) + (self.outras_aus2))
      if (verificando1 > 0 and verificando1  <= 15 )
          self.dias_trab1 = self.dias1 - (self.f_justif1 + self.f_injustif1 + self.afastamento1)
      else
          self.dias_trab1 = self.dias1 - (self.f_abonada1 + self.f_atestado1 + self.lic_saude1 + self.f_justif1 + self.f_injustif1 + self.afastamento1 + self.outras_aus1)
      end

    if (verificando2 > 0 and verificando2  <= 15 )
        self.dias_trab2 = self.dias2 - (self.f_justif2 + self.f_injustif2 + self.afastamento2)
    else
       self.dias_trab2 = self.dias2 - (self.f_abonada2 + self.f_atestado2 + self.lic_saude2 + self.f_justif2 + self.f_injustif2 + self.afastamento2 + self.outras_aus2)
    end
   self.dias_rede1 = self.dias_efetivos1
   self.dias_rede2 = self.dias_efetivos2

   self.subtot_dias = self.dias_trab1 + self.dias_trab2
   self.subtot_efetivo = self.dias_efetivos1 + self.dias_efetivos2
   self.dias_rede1 = self.dias1
   self.dias_rede2 = self.dias2
      self.subtot_rede = self.dias_rede1 + self.dias_rede2

    
end
end

def pontuacao_anterior
  professor = self.professor_id
  diasts =0
  efetivots=0
  redets=0
  unidts=0
  anoanteiror =  ((Time.current.strftime("%Y").to_i)-1)
  @total_anterior = TempoServico.find(:all , :conditions => ['professor_id =? and ano_letivo = ?',professor, anoanteiror])
  

  if ((@total_anterior.nil?) or (@total_anterior.empty?))
     self.total_ant_dias= 0
     self.total_ant_efetivo= 0
     self.total_ant_rede= 0
     if (Time.current.strftime("%Y").to_i)< (Time.now.year)
         self.total_ant_unid= 0
     end
  else
    @total_anterior.each do |tp|
      diasts = tp.total_dias
      efetivots = tp.total_efetivo
      redets = tp.total_rede
      if (Time.current.strftime("%Y").to_i)< (Time.now.year)
          unidts = tp.total_unid
      end
      t1=diasts
      t2=efetivots
      t3= redets
      t0=0
    end

     self.total_ant_dias= diasts
     self.total_ant_efetivo= efetivots
     self.total_ant_rede= redets
     self.total_ant_unid= unidts


     a1= self.total_ant_dias
     a2= self.total_ant_efetivo
     a3=self.total_ant_rede
     a4=self.total_ant_unid

    a=0
  end
end


def pontuacao_anterior
  professor_id = self.professor_id
  diasts =0
  efetivots=0
  redets=0
  unidts=0
  anoanteiror =  ((Time.current.strftime("%Y").to_i)-1)
  @total_anterior = TempoServico.find(:all , :conditions => ['professor_id =? and ano_letivo = ?',professor_id, anoanteiror])
  

  if ((@total_anterior.nil?) or (@total_anterior.empty?))
     self.total_ant_dias= 0
     self.total_ant_efetivo= 0
     self.total_ant_rede= 0
     if (Time.current.strftime("%Y").to_i)< (Time.now.year)
         self.total_ant_unid= 0
     end
  else
    @total_anterior.each do |tp|
      diasts = tp.total_dias
      efetivots = tp.total_efetivo
      redets = tp.total_rede
      if (Time.current.strftime("%Y").to_i)< (Time.now.year)
          unidts = tp.total_unid
      end
      t1=diasts
      t2=efetivots
      t3= redets
      t0=0
    end

     self.total_ant_dias= diasts
     self.total_ant_efetivo= efetivots
     self.total_ant_rede= redets
     self.total_ant_unid= unidts


     a1= self.total_ant_dias
     a2= self.total_ant_efetivo
     a3=self.total_ant_rede
     a4=self.total_ant_unid

  end
end


  def total_geral
    self.total_efetivo= ((self.dias_efetivos1 + self.dias_efetivos2) * 10) + self.total_ant_efetivo

    t=self.total_dias
    self.total_dias= ((self.dias_trab1 + self.dias_trab2 ) * 2)+ self.total_ant_dias
    t1=self.total_dias
    t=0
    self.total_rede= ((self.dias_rede1 + self.dias_rede2) * 1) + self.total_ant_rede
     if (Time.current.strftime("%Y").to_i)< (Time.now.year)
        self.total_unid= (self.total_ant_unid +  self.dias_unidade1 + self.dias_unidade2) * 2
     end
end

  def geral
     if (Time.current.strftime("%Y").to_i)< (Time.now.year)
         self.total_geral_tempo_servico = self.total_dias + self.total_efetivo + self.total_rede + self.total_unid
     else
         self.total_geral_tempo_servico = self.total_dias + self.total_efetivo + self.total_rede
     end
  end

  def total_pontuacao
    $ano =  Time.current.strftime("%Y").to_i
    professor =self.professor_id
    t=0
    #@tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo = ? ", $teacher,$ano] )
    #@tp = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + ($teacher).to_s + " and tp.ano_letivo="+($ano).to_s )
    @tp = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (professor).to_s + " and t.tipo = 'PERMANENTE'")
    @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (professor).to_s + " and t.tipo = 'ANUAL'" +" and tp.ano_letivo="+($ano).to_s  )
   
    if @tp.empty?
      $pontostituloP=0
    else
      @tp.each do |tp|
        $pontostituloP=  (tp.total_permanente)
      end
    end
    if @tp1.empty?
      $pontostituloA=0
    else
      @tp1.each do |tp|
        $pontostituloA= (tp.total_anual)
      end
    end

     $pontuacao_geral = self.total_geral_tempo_servico
     $geral =$pontuacao_geral + ($pontostituloA+$pontostituloP)


    end

  def atualiza_pontos_tabela_professor

     @professor= Professor.find(:all, :conditions =>['id= ?', self.professor_id])
    @professor.each do |prof|
      #prof.total_trabalhado = self.total_geral_tempo_servico
      #prof.total_titulacao= ($pontostituloA+$pontostituloP)
      prof.pontuacao_final= $geral
      prof.save
    end

  end

end
