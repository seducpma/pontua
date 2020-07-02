class TituloProfessor < ActiveRecord::Base
  belongs_to :titulacao
  belongs_to :professor
  validates_presence_of :professor_id, :message => ' -  PROFESSOR - PREENCHIMENTO OBRIGATÓRIO'
  validates_presence_of :quantidade, :dt_titulo, :message => ' ==> PREENCHER DE DADOS OBRIGATÓRIO <=='
  #before_save  :totaliza
  before_destroy :atualiza_pontos_tabela_professor

  before_save  :maiusculo

 def maiusculo
   if  !self.obs.nil?
        self.obs.upcase!
   end
   
 end
def totaliza


  if self.ano_letivo < Time.now.year
      t=0
    $totalgeral =0
    total_p=0
     total_a=0

      if ((self.titulo_id == 7) or (self.titulo_id == 11))and (self.quantidade < 30)
         self.pontuacao_titulo = 0
         self.total_anual = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?"  , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
         total_a = self.total_anual
         total_p = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ?" , professor, 1,5] )
      else if  ((self.titulo_id == 7) or (self.titulo_id == 11))and (self.quantidade > 29)
               self.pontuacao_titulo = self.quantidade * self.valor
               self.total_anual = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?"  , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
               total_a = self.total_anual
               total_p = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ?" , professor, 1,5] )
           else if ((self.titulo_id == 6) or (self.titulo_id == 7) or (self.titulo_id == 8)or (self.titulo_id == 9)or (self.titulo_id == 10) or (self.titulo_id == 12))
                 if (self.titulo_id ==12)
                    if (self.quantidade > 8)
                       self.pontuacao_titulo= self.quantidade.to_i * 1
                       self.total_anual = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?" , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
                       total_a = self.total_anual
                       total_p = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ?" , professor, 1,5] )
                    else
                       self.pontuacao_titulo= 8
                       self.total_anual = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?" , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
                       total_a = self.total_anual
                       total_p = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ?" , professor, 1,5] )
                    end
                 else
                     self.pontuacao_titulo= self.quantidade.to_i * self.valor.to_i
                   self.total_anual = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?" , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
                   total_a = self.total_anual
                   total_p = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ?" , professor, 1,5] )
                 end
                else if ((self.titulo_id == 1) or (self.titulo_id == 2) or (self.titulo_id == 3) or (self.titulo_id == 4) or (self.titulo_id == 5))
                        self.pontuacao_titulo= self.quantidade.to_i * self.valor.to_i
                        self.total_permanente = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ?" , professor, 1,5] )
                        total_p = self.total_permanente
                     end

                end

            end
      end


      self.total_titulacao = total_a + total_p
      $totalgeral =  self.total_titulacao
     # $subtot_permente =  TituloProfessor.find_by_sql (SELECT sum(`pontuacao_titulo`) FROM `titulo_professors` WHERE `professor_id`=1269)

  end

end

  def totaliza_permamente (professor)
    if (self.titulo_id == 1) or (self.titulo_id == 2) or (self.titulo_id == 3) or (self.titulo_id == 4) or (self.titulo_id ==5)
       titulos_permanente = TituloProfessor.find(:all, :conditions => ['professor_id = ? and titulo_id between ? and ? and ano_letivo = ?', professor, 1, 5,(Time.current.strftime("%Y")).to_i] )
       somatoria = 0
       titulos_permanente.each do |tp|
          somatoria = somatoria + tp.pontuacao_titulo
           self.total_permanente = somatoria
           tp.save
       end
       somatoria
    end


  end


def totaliza_anual (professor)
  if $ano = Time.current.strftime("%Y").to_i
  if (self.titulo_id == 6) or (self.titulo_id == 7) or (self.titulo_id == 8) or (self.titulo_id == 9) or (self.titulo_id == 10) or (self.titulo_id == 11) or (self.titulo_id == 12)
       titulos_anual = TituloProfessor.find(:all, :conditions => ['professor_id = ? and titulo_id between ? and ? and ano_letivo= ?', professor, 6, 12 , $ano ])
    somatoria1 = 0
       titulos_anual.each do |tp1|
          somatoria1 = somatoria1 + tp1.pontuacao_titulo
          self.total_anual = somatoria1
          tp1.save
       end
       somatoria1
    end
  end
  end


  def atualiza_pontos_tabela_professor
   @temposervico = TempoServico.find(:all,:conditions =>['professor_id = ? and ano_letivo = ?', self.professor_id, Time.now.year ])

   @temposervico.each do |ts|
     $total_geral_tempo_servico = ts.total_geral_tempo_servico
      ts.pontuacao_geral
      self.pontuacao_titulo

     $pontuacao_gerall = ts.pontuacao_geral - self.pontuacao_titulo
     $flaggravaprof = 0
     ts.pontuacao_geral= $pontuacao_gerall
      ts.save
   end
     if @temposervico.present?
          @professor= Professor.find(:all, :conditions =>['id= ?', self.professor_id])
          @professor.each do |prof|
             #prof.total_titulacao = prof.total_titulacao - self.pontuacao_titulo
             #prof.total_trabalhado = $total_geral_tempo_servico
             g4=$pontuacao_gerall
             g5=prof.pontuacao_final= $pontuacao_gerall
              prof.save
          end

   end
  end



end


