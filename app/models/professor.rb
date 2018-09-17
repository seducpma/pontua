class Professor < ActiveRecord::Base
  belongs_to :unidade, :class_name => "Unidade", :foreign_key => "sede_id"
  belongs_to :sede_id_ant
  has_one :tempo_servico, :dependent => :delete
  has_one :titulo_professor, :dependent => :delete
  
validates_presence_of :matricula, :message => ' -  MATRÍCULA - PREENCHIMENTO OBRIGATÓRIO'
validates_presence_of :nome, :message => ' -  NOME - PREENCHIMENTO OBRIGATÓRIO'
#validates_presence_of :funcao, :message => ' -  FUNÇÃO - PREENCHIMENTO OBRIGATÓRIO'
#validates_presence_of :sede_id, :message => ' -  SEDE - PREENCHIMENTO OBRIGATÓRIO'

#validates_numericality_of :INEP, :only_integer => true, :message =>  ' - SOMENTE NÚMEROS'
#validates_numericality_of :RD, :only_integer => true, :message =>  ' - SOMENTE NÚMEROS'
validates_uniqueness_of :matricula, :message => ' - PROFESSOR JA CADASTRADO'
Curso = ['Sem Magistério / Pedagogia','Magistério - Nível Médio','Pedagogia / Normal Superior','Licenciatura em Artes','Licenciatura em Educação Física','Licenciatura em Letras - Português','Licenciatura em Letras - Inglês','Licenciatura em Matemática','Licenciatura em História','Licenciatura em Geografia','Licenciatura em Ciências / Biologia']

  #after_create :log_cadastro
  before_update :atualiza
  before_save :caps_look

  def atualiza
   atualiza = Professor.find(self.id)
   if self.dt_nasc.nil?
        self.dt_nasc = atualiza.dt_nasc
   end
   if self.dt_ingresso.nil?
        self.dt_ingresso = atualiza.dt_ingresso
   end
   if self.sede_id.nil?
        self.sede_id = atualiza.sede_id
   end



  end

  def caps_look
    #self.pontuacao_final = (self.total_trabalhado + self.total_titulacao)
    self.nome.upcase!
    self.endres.upcase!
    self.bairro.upcase!
    self.complemento.upcase!
    self.cidade.upcase!
    self.funcao.upcase!
    self.obs.upcase!
  end

   def log_cadastro
    @atualiza_log = Log.new
    @atualiza_log.user_id = self.log_user
    @atualiza_log.professor_id = self.id
    @atualiza_log.obs = "Cadastrado um professor"
    @atualiza_log.data = (Time.now().strftime("%d/%m/%y %H:%M")).to_s
    @atualiza_log.save

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



end
