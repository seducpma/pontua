class TempoServicosController < ApplicationController
   before_filter :load_professors
   before_filter :load_professors1
    before_filter :load_consulta_ano

 def impressao
        @professor= Professor.find(:all,:conditions => ["id = ?  and desligado = 0",session[:teacher]])
        @temposervico = TempoServico.find(:all,:conditions =>['professor_id = ? and ano_letivo = ?', session[:teacher], session[:ano_letivo]])
   render :layout => "impressao"
end

  def index
    @temposervico = TempoServico.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temposervico }
    end
  end

  # GET /obreiros/1
  # GET /obreiros/1.xml
  def show
    @temposervico = TempoServico.find(params[:id])
    profid = @temposervico.professor_id
    @professor = Professor.find(:all, :conditions  => ["id = ? and desligado = 0", profid])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @temposervico }
    end
  end

  # GET /obreiros/new
  # GET /obreiros/new.xml
  def new
    $flaggravaprof = 1
    @temposervico = TempoServico.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @temposervico }
    end
  end

  # GET /obreiros/1/edit
  def edit
    @temposervico = TempoServico.find(params[:id])
  end

  # POST /obreiros
  # POST /obreiros.xml
  def create
    flaggravaprof = 1
   @temposervico = TempoServico.new(params[:tempo_servico])
   # @titulo_professor = TituloProfessor.new(params[:titulo_professor])

#   def salva_dados
    @temposervico.ano_letivo = Time.current.strftime("%Y").to_i
    @temposervico.ano1 = (Time.current.strftime("%Y").to_i)-1
    @temposervico.ano2 = Time.current.strftime("%Y").to_i
    @temposervico.dias_rede1 = @temposervico.dias1
    @temposervico.dias_rede2 = @temposervico.dias2
    somatoria1 = @temposervico.f_abonada1 + @temposervico.f_atestado1 + @temposervico.f_justif1 + @temposervico.f_injustif1 + @temposervico.lic_saude1 + @temposervico.afastamento1 + @temposervico.outras_aus1
    somatoria2 = @temposervico.f_abonada2 + @temposervico.f_atestado2 + @temposervico.f_justif2 + @temposervico.f_injustif2 + @temposervico.lic_saude2 + @temposervico.afastamento2 + @temposervico.outras_aus2
    somatoriaTotal = somatoria1+somatoria2
    if somatoriaTotal > 15
      @temposervico.dias_trab1 = (@temposervico.dias1 - (@temposervico.f_abonada1 + @temposervico.f_atestado1 + @temposervico.f_justif1 + @temposervico.f_injustif1 + @temposervico.lic_saude1 + @temposervico.afastamento1 + @temposervico.outras_aus1))
      # self.dias_efetivos1 = (self.dias1 - (self.f_abonada1 + self.f_atestado1 + self.f_justif1 + self.f_injustif1 + self.lic_saude1 + self.afastamento1 + self.outras_aus1))alterado por solicitação da Alessanda   7/12/2016
      @temposervico.dias_efetivos1 = (@temposervico.dias1 - (@temposervico.f_abonada1 + @temposervico.f_atestado1 + @temposervico.f_justif1 + @temposervico.f_injustif1 + @temposervico.lic_saude1 + @temposervico.afastamento1 ))
    else
      @temposervico.dias_trab1 = (@temposervico.dias1 - (@temposervico.f_justif1 + @temposervico.f_injustif1))
      #self.dias_efetivos1 = (self.dias1 - (self.f_abonada1 + self.f_atestado1 + self.f_justif1 + self.f_injustif1 + self.lic_saude1 + self.afastamento1 + self.outras_aus1))alterado por solicitação da Alessanda   7/12/2016
      @temposervico.dias_efetivos1 = (@temposervico.dias1 - (@temposervico.f_abonada1 + @temposervico.f_atestado1 + @temposervico.f_justif1 + @temposervico.f_injustif1 + @temposervico.lic_saude1 + @temposervico.afastamento1))
    end
    if somatoriaTotal > 15
      @temposervico.dias_trab2 = (@temposervico.dias2 - (@temposervico.f_abonada2 + @temposervico.f_atestado2 + @temposervico.f_justif2 + @temposervico.f_injustif2 + @temposervico.lic_saude2 + @temposervico.afastamento2 + @temposervico.outras_aus2))
      #self.dias_efetivos2 = (self.dias2 - (self.f_abonada2 + self.f_atestado2 + self.f_justif2 + self.f_injustif2 + self.lic_saude2 + self.afastamento2 + self.outras_aus2))alterado por solicitação da Alessanda   7/12/2016
      @temposervico.dias_efetivos2 = (@temposervico.dias2 - (@temposervico.f_abonada2 + @temposervico.f_atestado2 + @temposervico.f_justif2 + @temposervico.f_injustif2 + @temposervico.lic_saude2 + @temposervico.afastamento2))
    else
      @temposervico.dias_trab2 = (@temposervico.dias2 - (@temposervico.f_justif2 + @temposervico.f_injustif2))
      #self.dias_efetivos2 = (self.dias2 - (self.f_abonada2 + self.f_atestado2 + self.f_justif2 + self.f_injustif2 + self.lic_saude2 + self.afastamento2 + self.outras_aus2))alterado por solicitação da Alessanda   7/12/2016
      @temposervico.dias_efetivos2 = (@temposervico.dias2 - (@temposervico.f_abonada2 + @temposervico.f_atestado2 + @temposervico.f_justif2 + @temposervico.f_injustif2 + @temposervico.lic_saude2 + @temposervico.afastamento2))
    end
    @temposervico.subtot_dias = @temposervico.dias_trab1 + @temposervico.dias_trab2
    @temposervico.subtot_efetivo = @temposervico.dias_efetivos1 + @temposervico.dias_efetivos2
    @temposervico.subtot_rede = @temposervico.dias_rede1 + @temposervico.dias_rede2
    @temposervico.subtot_unid = @temposervico.dias_unidade1 + @temposervico.dias_unidade2


#def pontuacao_anterior
  professor_id =  @temposervico.professor_id
  diasts =0
  efetivots=0
  redets=0
  unidts=0
  anoanteiror =  ((Time.current.strftime("%Y").to_i)-1)
  @total_anterior = TempoServico.find(:all , :conditions => ['professor_id =? and ano_letivo = ?',professor_id, anoanteiror])


  if ((@total_anterior.nil?) or (@total_anterior.empty?))
     @temposervico.total_ant_dias= 0
     @temposervico.total_ant_efetivo= 0
     @temposervico.total_ant_rede= 0
     if (Time.current.strftime("%Y").to_i)< (Time.now.year)
          @temposervico.total_ant_unid= 0
     end
  else
    @total_anterior.each do |tp|
      diasts = tp.total_dias
      efetivots = tp.total_efetivo
      redets = tp.total_rede
      if (Time.current.strftime("%Y").to_i)< (Time.now.year)
          unidts = tp.total_unid
      end
    end

      @temposervico.total_ant_dias= diasts
      @temposervico.total_ant_efetivo= efetivots
      @temposervico.total_ant_rede= redets
      @temposervico.total_ant_unid= unidts


      a1=@temposervico.total_ant_dias
      a2=@temposervico.total_ant_efetivo
      a3=@temposervico.total_ant_rede
      a4=@temposervico.total_ant_unid

  end



#  def total_geral

    @temposervico.total_efetivo= ((@temposervico.dias_efetivos1 + @temposervico.dias_efetivos2) * 10) + @temposervico.total_ant_efetivo

    @temposervico.total_dias
    @temposervico.total_dias= ((@temposervico.dias_trab1 + @temposervico.dias_trab2 ) * 2)+ @temposervico.total_ant_dias
    @temposervico.total_dias
    @temposervico.total_rede= ((@temposervico.dias_rede1 + @temposervico.dias_rede2) * 1) + @temposervico.total_ant_rede
     if (Time.current.strftime("%Y").to_i)< (Time.now.year)
        @temposervico.total_unid= (@temposervico.total_ant_unid +  @temposervico.dias_unidade1 + @temposervico.dias_unidade2) * 2
     end
     
  #  def geral
     if (Time.current.strftime("%Y").to_i)< (Time.now.year)
         @temposervico.total_geral_tempo_servico = @temposervico.total_dias + @temposervico.total_efetivo + @temposervico.total_rede + @temposervico.total_unid
     else
         @temposervico.total_geral_tempo_servico = @temposervico.total_dias + @temposervico.total_efetivo + @temposervico.total_rede
     end

#def total_pontuacao
    ano =  Time.current.strftime("%Y").to_i
    professor =@temposervico.professor_id
    #@tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo = ? ", $teacher,$ano] )
    #@tp = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + ($teacher).to_s + " and tp.ano_letivo="+($ano).to_s )
    @tp = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (professor).to_s + " and t.tipo = 'PERMANENTE'")
    @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (professor).to_s + " and t.tipo = 'ANUAL'" +" and tp.ano_letivo="+(ano).to_s  )

    if @tp.empty?
      pontostituloP=0
    else
      @tp.each do |tp|
        pontostituloP=  (tp.total_permanente)
      end
    end
    if @tp1.empty?
      pontostituloA=0
    else
      @tp1.each do |tp|
        pontostituloA= (tp.total_anual)
      end
    end
     geral_titulo = (pontostituloA+pontostituloP)
      pontuacao_geral = @temposervico.total_geral_tempo_servico + geral_titulo
     
        if session[:altera_tabelas] != 1
            @temposervico.pontuacao_geral = geral_titulo+ @temposervico.total_geral_tempo_servico
        end




# def atualiza_pontos_tabela_professor
     
     @professor= Professor.find(@temposervico.professor_id)
     @professor.total_trabalhado= @temposervico.total_geral_tempo_servico
     @professor.pontuacao_final= geral_titulo + @temposervico.total_geral_tempo_servico

     @professor.save






    respond_to do |format|
      if @temposervico.save
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@temposervico) }
        format.xml  { render :xml => @temposervico, :status => :created, :location => @temposervico }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @temposervico.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @temposervico = TempoServico.find(params[:id])
    respond_to do |format|
      if @temposervico.update_attributes(params[:tempo_servico])
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@temposervico) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @temposervico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /obreiros/1
  # DELETE /obreiros/1.xml
  def destroy
    @temposervico = TempoServico.find(params[:id])
    @temposervico.destroy

    respond_to do |format|
      format.html { redirect_to(TempoServicos_url) }
      format.xml  { head :ok }
    end
  end

 def sel_prof
        existe = 1
      $teacher = params[:titulo_professor_professor_id]
      session[:teacher]= params[:titulo_professor_professor_id]
        
        $professor_id = $teacher
        session[:professor_id] = session[:teacher]
        $id_professor = $professor_id
        session[:id_professor]= session[:professor_id]
        session[:professor] = Professor.find(session[:teacher]).nome
        $professor = Professor.find(session[:teacher]).nome
        @professor = Professor.find(:all,:conditions => ['id = ? and desligado = 0 ', session[:teacher]])
        @temposervico = TempoServico.find(:all,:conditions =>['professor_id = ?  and ano_letivo = ?', session[:teacher], Time.current.strftime("%Y").to_i])
         if !@temposervico.empty?
           existe = 0
         else
         existe = 1
         end
         render :update do |page|
          page.replace_html 'nomeprof', :text => '- ' + (session[:professor])
          if existe == 0
            page.replace_html 'cadastrar', :text => ' JÁ CADASTRADO'
            page.replace_html 'cadastrar1', :text => ''
            page.replace_html 'cadastrar2', :text=> 'ACESSAR NOVAMENTE O MENU'
          else
            
            page.replace_html 'new'
         end
        end
      end




def consulta


end


def consulta_tempo_servico
      
      teacher = params[:consulta][:professor_id]
      $teacher_ts = params[:consulta][:professor_id]
      #$teache_anterior =  session[:teacher]
       $ano =(Time.now.year)
       session[:ano_letivo]= params[:ano_letivo]
       @professor= Professor.find(:all,:conditions => ["id = ? and desligado = 0",teacher])
       @temposervico = TempoServico.find(:all,:conditions =>['professor_id = ? and ano_letivo = ?', teacher, session[:ano_letivo]])
        render :update do |page|
          page.replace_html 'titulos', :partial => 'mostrar_pontuacao_tempo'

        end
end
 
  def consulta_nome
    render 'consulta_nome'
  end



 

 protected


  def load_professors
    @professors = Professor.find(:all,:conditions => ['desligado = 0 '] , :order => "matricula ASC")
  end

  def load_professors1
    @professors1 = Professor.find(:all, :conditions => ["desligado = 0"], :order => "matricula ASC")
  end

  def load_consulta_ano
    @ano = TempoServico.find(:all,:select => 'distinct(ano_letivo) as ano',:order => 'ano_letivo DESC')
    @ano1 = TempoServico.find(:all,:select => 'distinct(ano_letivo) as ano', :conditions => ['ano_letivo > 2014'],:order => 'ano_letivo DESC')

  end

end
