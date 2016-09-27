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
   @temposervico = TempoServico.new(params[:tempo_servico])
   # @titulo_professor = TituloProfessor.new(params[:titulo_professor])

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
        #$professor_id = Professor.find_by_matricula($teacher).id
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
