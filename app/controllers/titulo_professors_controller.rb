class TituloProfessorsController < ApplicationController
  before_filter :load_titulacao
  before_filter :load_consulta_ano
  before_filter :load_professors
  before_filter :load_professors1
  before_filter :load_professors_consulta
  before_filter :professor_unidade
  before_filter :login_required
#  require_role ["supervisao","planejamento","administrador"], :for_all_except => [:search,:search_by_desc,:search_by_professor_titulos_anuais,:relatorio_titulos_anuais_invalidos,:relatorio_por_descricao_titulo, :relatorio_prof_titulacao,:update, :titulos_busca, :destroy, :index, :new, :create, :sel_prof, :busca_prof, :guarda_valor1, :guarda_valor, :nome_professor]
  # GET /titulo_professors
  # GET /titulo_professors.xml
  layout :define_layout

  def define_layout
      current_user.layout
  end
def consulta
  
end

def consulta_titulacao_professor
  
end


def consulta_titulacao_professor
   if (params[:search].nil? || params[:search].empty?)
      titulo = 0
      $titulo = 0
   else
      titulo = params[:search][:search]
      $titulo = params[:search][:search]
   end
    if $titulo != 0
           @tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.titulo_id =?  ", $titulo] )
           #@tp = TituloProfessor.find(:all,  :conditions =>["titulo_professors.titulo_id =?  ", $titulo] )

    end
  end


def sel_prof
  t=0
        
       
        #$professor_id = Professor.find_by_matricula($teacher).id
       
        
        professor = Professor.find(params[:titulo_professor_professor_id]).nome
        @professor = Professor.find(:all,:conditions => ['id = ? and desligado = 0 ', params[:titulo_professor_professor_id]])
        @temposervico = TempoServico.find(:all,:conditions =>['professor_id = ?  and ano_letivo = ?', params[:titulo_professor_professor_id], Time.current.strftime("%Y").to_i])
         if !@temposervico.empty?
           existe = 0
         else
          existe = 1
         end
         t1=0
         render :update do |page|
          page.replace_html 'nomeprof', :text => '- ' + (professor)
          if existe == 0
            page.replace_html 'cadastrar', :text => ' JÁ CADASTRADO'
            page.replace_html 'cadastrar1', :text => ''
            page.replace_html 'cadastrar2', :text=> 'ACESSAR NOVAMENTE O MENU'
          else

            page.replace_html 'new'
         end
        end
      end



  #Relatorio por tiulos

  def relatorio_prof_titulacao
    if (params[:titulo_id]).present?
    if (params[:accept]).present?
      @relatorio_tit_prof = TituloProfessor.paginate(:all, :page=>params[:page],:per_page =>20,:conditions => ["titulo_id <> ?",params[:titulo_id][:titulo_id]], :include => ['professor'],:order => 'professors.nome')
    else
      @relatorio_tit_prof = TituloProfessor.paginate(:all, :page=>params[:page],:per_page =>20,:conditions => ["titulo_id = ?", params[:titulo_id][:titulo_id]], :include => ['professor'],:order => 'professors.nome')
    end
   else
     @relatorio_tit_prof = "Selecione um titulo para filtragem"
   end
    render :action => 'relatorio_prof_titulacao'

  end

  def search
  end

#=====================================================================================================================================================================

# Relatorio pela descrição do titulo

  def relatorio_por_descricao_titulo

   if (params[:titulo]).present?
     #@relatorio_por_descricao_titulo = TituloProfessor.obs_like(params[:titulo])
     @relatorio_por_descricao_titulo = TituloProfessor.paginate(:all,:page=>params[:page],:per_page =>20,:conditions => ["obs like ? and titulo_id = 1",params[:titulo]])
   else
     @relatorio_por_descricao_titulo = "Descreva o titulo para filtragem"
   end
    render :action => 'relatorio_por_descricao_titulo'


  end

  def search_by_desc
  end


#====================================================================================================================================================================
# Relatorio titulos anuais invalidos

  def relatorio_titulos_anuais_invalidos
    if (params[:professor_id]).present?
     @relatorio_tit_prof = TituloProfessor.paginate(:all,:page=>params[:page],:per_page =>20,:conditions => ["professor_id = ? and (titulo_id = 6 or titulo_id = 7 or titulo_id = 8) and ano_letivo <> ?",params[:professor_id][:professor_id], Time.current.strftime("%Y")])
   else
     @relatorio_tit_prof = "Selecione o professor"
   end
    render :action => 'relatorio_titulos_anuais_invalidos'
  end

  def search_by_professor_titulos_anuais

  end

#====================================================================================================================================================================
  
  def index
    @titulo_professors = TituloProfessor.find(:all, :conditions => ['professor_id =?', session[:teacher]])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @titulo_professors }
    end
  end

  # GET /titulo_professors/1
  # GET /titulo_professors/1.xml
  def show
    @titulo_professor = TituloProfessor.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @titulo_professor }
    end
  end

  # GET /titulo_professors/new
  # GET /titulo_professors/new.xml
  def new
    @titulo_professor = TituloProfessor.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @titulo_professor }
    end
  end

  # GET /titulo_professors/1/edit
  def edit
    @tp = TituloProfessor.find(params[:id])
  end

  # POST /titulo_professors
  # POST /titulo_professors.xml
  def create

    @titulo_professor = TituloProfessor.new(params[:titulo_professor])
    @titulo_professor.valor= session[:valor]
    @titulo_professor.ano_letivo =Time.current.strftime("%Y")

    w1=@titulo_professor.tipo_curso
    w=@titulo_professor.titulo_id
    w2=professor =  @titulo_professor.professor_id
    w3=@titulo_professor.titulo_id
    w4=@titulo_professor.quantidade.to_i
    w5= @titulo_professor.valor.to_i



    t=0
    #$totalgeral =0
    total_p=0
    total_a=0
    teste_120=0

      if ((@titulo_professor.titulo_id == 7) or (@titulo_professor.titulo_id == 11))and (@titulo_professor.quantidade < 30)
         @titulo_professor.pontuacao_titulo = 0
         @titulo_professor.total_anual = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?"  , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
        total_anualA = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?" , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
        total_a = @titulo_professor.total_anual = total_anualA +@titulo_professor.pontuacao_titulo
         total_p = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ?" , professor, 1,5] )
         t=0
      else if  ((@titulo_professor.titulo_id == 7) or (@titulo_professor.titulo_id == 11)) and (@titulo_professor.quantidade > 29)
               #mais120 = TituloProfessor.find(:all, :conditons =>[ '(id = 11 or id = 7) AND  pontuacao_titulo >120 AND ano_letivo = ?', Time.now.year])
               quantidade = @titulo_professor.quantidade
               
               @mais120  = TituloProfessor.find(:all, :conditions =>[ '(titulo_id = 11 or titulo_id = 7) AND ano_letivo = ? AND professor_id=?', Time.now.year, @titulo_professor.professor_id])
               t=0
               for mais120 in @mais120
                  teste_120 = mais120.pontuacao_titulo + teste_120
               end
               total_antes = teste_120
               teste_120 = teste_120 + quantidade
               if teste_120 > 120
                  teste_120 = (120 - total_antes)
               else
                  teste_120 = quantidade
               end
               t=0
                    if ((@titulo_professor.titulo_id == 7) or (@titulo_professor.titulo_id == 11)) and ((@titulo_professor.quantidade > 120))
                        t0=0
                       @titulo_professor.pontuacao_titulo = 120 * @titulo_professor.valor
                    else
                      t=0
                        if ((@titulo_professor.titulo_id == 7) or (@titulo_professor.titulo_id == 11)) and @titulo_professor.quantidade<=120
                           if (teste_120>=0 and teste_120<=120)
                              @titulo_professor.pontuacao_titulo = teste_120 * @titulo_professor.valor
                              t=0
                           else

                              if ((@titulo_professor.titulo_id == 7) or (@titulo_professor.titulo_id == 11)) and ((@titulo_professor.quantidade > 120) or ((total_antes+quantidade)<120))
                               @titulo_professor.pontuacao_titulo=0
t=0
                              else
                                 @titulo_professor.pontuacao_titulo = @titulo_professor.quantidade * @titulo_professor.valor
                              t=0
                              end
                           end
                        end
                    end
                       @titulo_professor.total_anual = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?"  , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
                        total_anualA = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?" , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
                        total_a = @titulo_professor.total_anual = total_anualA +@titulo_professor.pontuacao_titulo
                        total_p = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ?" , professor, 1,5] )
           else if ((@titulo_professor.titulo_id == 6) or (@titulo_professor.titulo_id == 7) or (@titulo_professor.titulo_id == 8)or (@titulo_professor.titulo_id == 9)or (@titulo_professor.titulo_id == 10) or (@titulo_professor.titulo_id == 12))
                         if (@titulo_professor.titulo_id ==12)
                            if (@titulo_professor.quantidade > 8)
                               @titulo_professor.pontuacao_titulo= @titulo_professor.quantidade.to_i * 1
                               @titulo_professor.total_anual = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?" , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
                                total_anualA = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?" , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
                                total_a = @titulo_professor.total_anual = total_anualA +@titulo_professor.pontuacao_titulo
                                 total_p = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ?" , professor, 1,5] )
                            else
                               @titulo_professor.pontuacao_titulo= 8
                               @titulo_professor.total_anual = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?" , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
                                total_anualA = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?" , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
                                total_a = @titulo_professor.total_anual = total_anualA +@titulo_professor.pontuacao_titulo
                                 total_p = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ?" , professor, 1,5] )
                            end
                         else

                           @titulo_professor.pontuacao_titulo=  @titulo_professor.quantidade  * @titulo_professor.valor
                           total_anualA = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ? and ano_letivo = ?" , professor, 6,12, (Time.current.strftime("%Y")).to_i] )
                           total_a = @titulo_professor.total_anual = total_anualA +@titulo_professor.pontuacao_titulo
                           total_p = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and titulo_id between ? and ?" , professor, 1,5] )
                         end
                        else if ((@titulo_professor.titulo_id == 1) or (@titulo_professor.titulo_id == 2) or (@titulo_professor.titulo_id == 3) or (@titulo_professor.titulo_id == 4) or (@titulo_professor.titulo_id == 5))
                                 pontuacao_titulo =0
                                 pontuacao_latus =0
                                 pontuacao_especilizacao=0
                                if (@titulo_professor.titulo_id == 5) or (@titulo_professor.titulo_id == 2)
                                    if (@titulo_professor.titulo_id == 2)
                                        tipo2_lotosensu= TituloProfessor.count(:id,  :conditions => ["professor_id = ? and titulo_id =? and ano_letivo =?" , professor, 2, @titulo_professor.ano_letivo] )
                                        tipo2_lotosensu_limite = TituloProfessor.count(:id,  :conditions => ["professor_id = ? and titulo_id =?" , professor, 2] )
                                    else
                                        tipo2_lotosensu= 1000000
                                        tipo2_lotosensu_limite = 1000000
                                    end
                                    if (@titulo_professor.titulo_id == 5)
                                          tipo5_especializacao= TituloProfessor.count(:id,  :conditions => ["professor_id = ? and titulo_id =? and ano_letivo =?" , professor, 5, @titulo_professor.ano_letivo] )
                                          tipo5_especializacao_limite = TituloProfessor.sum(:pontuacao_titulo,  :conditions => ["professor_id = ? and titulo_id =?" , professor, 5] )
                                    else
                                          tipo5_especializacao=1000000
                                          tipo5_especializacao_limite =1000000
                                    end
                                      if ((tipo5_especializacao < 1) and (tipo5_especializacao_limite <= 7000))
                                           session[:criterio]=1
                                           pontuacao_especilizacao= @titulo_professor.quantidade.to_i * @titulo_professor.valor.to_i
                                           @titulo_professor.pontuacao_titulo= @titulo_professor.quantidade.to_i * @titulo_professor.valor.to_i
                                      else
                                           pontuacao_especilizacao= 0
                                      end
                                      if ((tipo2_lotosensu < 1) and (tipo2_lotosensu_limite < 5))
                                           session[:criterio]=1
                                           pontuacao_latus= @titulo_professor.quantidade.to_i * @titulo_professor.valor.to_i
                                           @titulo_professor.pontuacao_titulo= @titulo_professor.quantidade.to_i * @titulo_professor.valor.to_i
                                      else
                                           pontuacao_latus= 0
                                      end
                                else
                                      pontuacao_titulo= @titulo_professor.quantidade.to_i * @titulo_professor.valor.to_i
                                      @titulo_professor.pontuacao_titulo= @titulo_professor.quantidade.to_i * @titulo_professor.valor.to_i
                                end
                                vartotal_permanente = TituloProfessor.sum(:pontuacao_titulo, :conditions => ["professor_id = ? and (titulo_id between ? and ?)  " , professor, 1,5] )
                                @titulo_professor.total_permanente=  vartotal_permanente + pontuacao_titulo+ pontuacao_latus + pontuacao_especilizacao
                                total_p = @titulo_professor.total_permanente
                             end
                        end
                    end
            # end
      end
t=0
      @titulo_professor.total_titulacao = total_a + total_p

      @professor=Professor.find(@titulo_professor.professor_id)
      @tp = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (@titulo_professor.professor_id).to_s + " and t.tipo = 'PERMANENTE'")
      @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (@titulo_professor.professor_id).to_s + " and t.tipo = 'ANUAL' and ano_letivo = " + (Time.now.year).to_s + " ")
      session[:subtot_um_TP]=0
      session[:subtot_perm_TP]=0
        for tp1 in @tp1
          teste = Time.current.strftime("%Y")
          (tp1.ano_letivo).to_s == Time.current.strftime("%Y")
               session[:subtot_um_TP] = session[:subtot_um_TP] + (tp1.pontuacao_titulo)

            tituloprof= tp1.professor_id
           session[:ano] = tp1.ano_letivo
            anual = session[:subtot_um_TP]
            permanente = session[:subtot_perm_TP]
          end
        if total_anualA.nil? or pontuacao_especilizacao.nil?
            total_anualA = 0
            pontuacao_especilizacao = 0
        end
        if ((@titulo_professor.titulo_id == 6) or (@titulo_professor.titulo_id == 7) or (@titulo_professor.titulo_id == 8)or (@titulo_professor.titulo_id == 9)or (@titulo_professor.titulo_id == 10) or (@titulo_professor.titulo_id == 11) or (@titulo_professor.titulo_id == 12))
           @professor.total_titulacao =  total_a + total_p
        else
           @professor.total_titulacao =  session[:subtot_um_TP] + total_p
        end
        @professor.pontuacao_final = @professor.total_trabalhado + @professor.total_titulacao
      @professor.save

    respond_to do |format|
      if @titulo_professor.save
        flash[:notice] = 'TITULAÇÃO CADASTRADA COM SUCESSO.'
        format.html { redirect_to(@titulo_professor)}
        format.xml  { render :xml => @titulo_professor, :status => :created, :location => @titulo_professor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @titulo_professor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /titulo_professors/1
  # PUT /titulo_professors/1.xml
  def update
    @titulo_professor = TituloProfessor.find(params[:id])
    @at_log = Log.new
    @at_log.titulacao_id = @titulo_professor.id
    @at_log.obs = "Atualizado"
    @at_log.professor_id = @titulo_professor.professor_id
    @at_log.user_id = current_user.id
    @at_log.save
    respond_to do |format|
      if @titulo_professor.update_attributes(params[:titulo_professor])
        flash[:notice] = 'TITULO ATUALIZADO COM SUCESSO'
        format.html { redirect_to(titulo_professor_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @titulo_professor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /titulo_professors/1
  # DELETE /titulo_professors/1.xml
  def destroy
      session[:subtot_ano_TP]=0
      session[:subtot_perm_TP]=0
      permanente =0
      anual=0

      @titulo_professor = TituloProfessor.find(params[:id])
      
      @titulo_professor.destroy
      
      id=@titulo_professor.id

      ponto_subtracao =   @titulo_professor.pontuacao_titulo
      @professor=Professor.find(@titulo_professor.professor.id)
      @titulo_professor_apos = TituloProfessor.find(:all,:conditions => ['professor_id=? and ano_letivo = ?  AND id > ? ', @titulo_professor.professor_id, Time.now.year, @titulo_professor.id])
      t=0
#ANUAL
      if @titulo_professor.total_permanente == 0
          for tpp in @titulo_professor_apos
              if tpp.total_permanente == 0
                  tpp.total_anual =  tpp.total_anual- ponto_subtracao
              end
              tpp.total_titulacao  =  tpp.total_titulacao-ponto_subtracao
              total_titulacao =  tpp.total_titulacao
              tpp.save
          end
      else
#PERMEANENTE
          for tpp in @titulo_professor_apos
              if tpp.total_permanente != 0
                  tpp.total_permanente =  tpp.total_permanente-ponto_subtracao

              end
              tpp.total_titulacao  =  tpp.total_titulacao-ponto_subtracao
              total_titulacao =  tpp.total_titulacao
              tpp.save
          end

      end
      if !@titulo_professor_apos.present?
         @titulo_professor_ultimo = TituloProfessor.find(:last,:conditions => ['professor_id=? and ano_letivo = ?  ', @titulo_professor.professor_id, Time.now.year])
          total_titulacao = @titulo_professor_ultimo.total_titulacao
      end
#      @tempo_servico= TempoServico.find(:all, :conditions=> ['professor_id =? and ano_letivo=?',id, Time.now.year])
      @professor.total_titulacao = total_titulacao

      @professor.pontuacao_final = @professor.total_trabalhado + total_titulacao

          if @tempo_servico.present?
               @professor.pontuacao_final
               @tempo_servico[0].pontuacao_geral
               @tempo_servico[0].pontuacao_geral = @professor.pontuacao_final
               @tempo_servico[0].pontuacao_geral
          end
#       @tempo_servico[0].save
       @professor.save

    respond_to do |format|
      format.html { redirect_to(new_titulo_professor_path) }
      format.xml  { head :ok }
    end
  end


  def sel_prof
    #$teacher = params[:titulo_professor_professor_id]
    session[:teacher]=params[:titulo_professor_professor_id]
    if !(session[:teacher].nil? or session[:teacher].empty?) or session[:teacher] == '' then
      if (Professor.find(session[:teacher])).nil? then
         render :update do |page|
           page.replace_html 'nomeprof', :text => 'Matricula não cadastrada'
           page.replace_html 'titulos', :text => ''
         end
      else

        # $professor_id = Professor.find_by_matricula($teacher).id
        
        
        $professor_id = session[:teacher]
        
        $id_professor = $professor_id
        # $professor = Professor.find(session[:teacher]).nome
        session[:professor]=Professor.find(session[:teacher]).nome
        @professor = Professor.find(:all,:conditions => ['id = ? and desligado = 0', session[:teacher]])
        @tp = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (session[:teacher]).to_s + " and t.tipo = 'PERMANENTE'")
        @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (session[:teacher]).to_s + " and t.tipo = 'ANUAL'")
        #@tp5 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + ($teacher).to_s + " and t.tipo = '5 ANOS'")
        
        render :update do |page|
          page.replace_html 'nomeprof', :text => '- ' + (session[:professor])
          page.replace_html 'titulos', :partial => 'mostrar_pont_titulos'
        end
      end
    end
  end

  def busca_prof
    render :update do |page|
      page.replace_html 'titulos', :partial => 'mostrar_pont_titulos'
    end
    $professor_id = nil
    #$teacher = nil
    session[:teacher]=nil
  end

  def guarda_valor1

    #$id_titulo = params[:titulo_professor_titulo_id]
    $session[:valor] = Titulacao.find_by_id(params[:titulo_professor_titulo_id]).valor

    render :update do |page|
      page.replace_html 'valor', :text => 'Pontuação do Título: ' + session[:valor].to_s
      #page.replace_html 'titulos', :partial => 'totaliza_titulo'
    end


  end

  def guarda_valor

    
    session[:valor] = Titulacao.find_by_id(params[:titulo_professor_titulo_id]).valor

    if params[:titulo_professor_titulo_id].to_i == 8 or params[:titulo_professor_titulo_id].to_i == 6 or params[:titulo_professor_titulo_id].to_i == 9 or params[:titulo_professor_titulo_id].to_i == 10
      render :update do |page|
        page.replace_html 'a_distancia', :text => ""
        page.replace_html 'a_distancia1', :text => ""
        page.replace_html 'valor', :text => '1) Pontuação: ' + session[:valor].to_s + ' pontos  por hora'
        page.replace_html 'qtde', :text => " <input id='titulo_professor_quantidade' type='text' value='0' size='10' name='titulo_professor[quantidade]'>"
        page.replace_html 'lanca', :text => "2) Lançar no campo 'QUANTIDADE' a carga horária do curso. Exemplo: 30 "
        page.replace_html 'tipo', :text => "de <b>horas</b> "
       page.replace_html 'horas', :text => "  (<font color=red><b><u>ATENÇÃO:</b></u></font> Lançar a <b><u>QUANTIDADE de HORAS</b></u>)"
       page.replace_html 'ead', :text => ""
      end
    else
      if params[:titulo_professor_titulo_id].to_i == 1 || params[:titulo_professor_titulo_id].to_i == 2 || params[:titulo_professor_titulo_id].to_i == 3 || params[:titulo_professor_titulo_id].to_i == 4 
        render :update do |page|
          page.replace_html 'a_distancia', :text => ""
          page.replace_html 'a_distancia1', :text => ""
          page.replace_html "qtde", :text => "1"
          page.replace_html 'valor', :text => '1) Pontuação: ' + session[:valor].to_s+ ' por título' 
          page.replace_html 'lanca', :text => "2) Lançar no campo 'QUANTIDADE' a quantiade de título. Exemplo: 1"
          page.replace_html 'tipo', :text => "de <b>título</b> "
          page.replace_html 'horas', :text => "(<font color=red><b><u>ATENÇÃO:</b></u></font> Lançar a <b><u>QUANTIDADE de TÍTULOS</b></u>)"
          page.replace_html 'ead', :text => ""
        end
      else
        if params[:titulo_professor_titulo_id].to_i == 5
            render :update do |page|
              page.replace_html 'a_distancia', :text => "1) Valido somente 1 título por ano"
              page.replace_html 'a_distancia1', :text => "2) Limite máximo da pontuação = 7000"
              page.replace_html "qtde", :text => "1"
              page.replace_html 'valor', :text => '3) Pontuação: ' + session[:valor].to_s+ ' por título'
              page.replace_html 'lanca', :text => "4) Lançar no campo 'QUANTIDADE' a quantiade de título exemplo: 1"
               page.replace_html 'tipo', :text => " de <b>título</b> "
              page.replace_html 'horas', :text => " (<font color=red><b><u>ATENÇÃO:</b></u></font> Lançar a <b><u>QUANTIDADE de TÍTULOS</b></u>)"
               page.replace_html 'ead', :text => ""
            end
        else
            if params[:titulo_professor_titulo_id].to_i == 7 or params[:titulo_professor_titulo_id].to_i == 11
              render :update do |page|
                # page.replace_html 'a_distancia', :text => "1) Se CURSO À DISTANCIA verificaque  a caixa de seleção PRESENCIAL esta desmarcada"
                page.replace_html 'a_distancia1', :text => "1) CURSOS À DISTANCIA NA ÁREA DE ATUAÇÃO DO PROFESSOR: válidos somente para cursos com carga horario mínima de 30 horas."
                page.replace_html 'tipo_titulo', :text => "<input id='titulo_professor_tipo_curso' type='checkbox' value='1' name='titulo_professor[tipo_curso]' value='false'> Presencial"
                page.replace_html 'valor', :text => '2) Pontualçao: ' + (session[:valor]).to_s + ' pontos por hora (EAD até o limite de 120 pontos no ano letivo), o que exceder será descontado.'
                page.replace_html 'qtde', :text => "<input id='titulo_professor_quantidade' type='text' value='0' size='10' name='titulo_professor[quantidade]'>"
                page.replace_html 'lanca', :text => "3) Lançar no campo 'QUANTIDADE' a carga horária do curso. Exemplo: 30"
                page.replace_html 'tipo', :text => "de <b>horas</b> "
                page.replace_html 'horas', :text => " (<font color=red><b><u>ATENÇÃO:</b></u></font> Lançar a <b><u>QUANTIDADE de HORAS</b></u>)"
                page.replace_html 'ead', :text => "  CURSOS EAD FORA DA AREA DE ATUAÇÃO DO PROFESSOR NÃO SÃO VÁLIDOS. "
              end
            else
              if params[:titulo_professor_titulo_id].to_i == 12
                render :update do |page|
                  page.replace_html 'a_distancia', :text => ""
                  page.replace_html 'a_distancia1', :text =>  " 1) Quantidade de horas superior a 8 horas é computado 1 ponto por hora "
                  page.replace_html "qtde", :text => "1"
                  page.replace_html 'valor', :text => '2) Pontuação: ' + session[:valor].to_s + ' pontos até 8 horas'
                  page.replace_html 'lanca', :text => "3) Lançar no campo 'QUANTIDADE' a carga horária do curso. Exemplo: 8 "
                  page.replace_html 'horas', :text => "<b> horas</b> (<font color=red><b><u>ATENÇÃO:</b></u></font> Lançar a <b><u> QUANTIDADE de HORAS</b></u>)"
                  page.replace_html 'ead', :text => ""
                end
              end
           end
        end
      end
    end
      if params[:titulo_professor_titulo_id].to_i == 100
        render :update do |page|
          page.replace_html 'a_distancia', :text => ""
          page.replace_html 'a_distancia1', :text => ""
          page.replace_html "qtde", :text => "1"
          page.replace_html 'valor', :text => '1) Pontuação: ' + (session[:valor]).to_s
          page.replace_html 'lanca', :text => " "
          page.replace_html 'horas', :text => "<b>título</b> (<font color=red><b><u>ATENÇÃO:</b></u></font> Lançar a <b><u>QUANTIDADE de TÍTULOS</b></u> em nº inteiros)"
          page.replace_html 'ead', :text => ""
        end
      end


    
  end


  def nome_professor

    $id_professor = params[:titulo_professor_titulo_id]
    # $professor = Professor.find_by_id($id_professor).nome
    session[:professor] = Professor.find_by_id(params[:titulo_professor_titulo_id]).nome
    render :update do |page|
      page.replace_html 'nome', :text => 'Nome:: ' + ($professror)
      #page.replace_html 'titulos', :partial => 'totaliza_titulo'
    end

  end




  

 def titulos_busca
    # $professor = Professor.find(params[:altera_professor_id]).nome
     session[:professor]= Professor.find(params[:altera_professor_id]).nome
     @titulo_busca =  TituloProfessor.find(:all,:conditions =>['professor_id = ? and (ano_letivo = ? or titulo_id in (1,2,3,4,5))',params[:altera_professor_id],Time.current.strftime("%Y")], :order => "created_at DESC")
      render :update do |page|
        page.replace_html 'nomeprof', :text => '- ' + (session[:professor])
        page.replace_html 'alteracao', :partial => 'alterar'
      end
 end


 def impressao
        @professor= Professor.find(:all,:conditions => ["id = ?  and desligado = 0",session[:teacher]])
        @tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo between ? and ? and titulacaos.tipo = 'PERMANENTE'", session[:teacher], 2009,session[:ano]] )
        @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (session[:teacher]).to_s + " and t.tipo = 'ANUAL'and ano_letivo ="+session[:ano].to_s)
       render :layout => "impressao"
end

def consulta_titulo_professor
     #$teacher = params[:consulta][:professor_id]
     session[:teacher]= params[:consulta][:professor_id]
      $ano = params[:ano_letivo]
      session[:ano]= params[:ano_letivo]
        @professor= Professor.find(:all,:conditions => ["id = ? and desligado = 0",session[:teacher]])
        @tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo between ? and ? and titulacaos.tipo = 'PERMANENTE'", session[:teacher], 2009,session[:ano]] )
        @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (session[:teacher]).to_s + " and t.tipo = 'ANUAL'and ano_letivo ="+session[:ano])
           render :update do |page|
          page.replace_html 'titulos', :partial => 'mostrar_pont_titulos_1'
        end
end


 protected

  def load_titulacao
    @titulacaos = Titulacao.find(:all)
    @titulacaos1 = Titulacao.find(:all, :conditions =>["ano_letivo_titulacao > 2014 or ano_letivo_titulacao =0"])
  end

  def load_professors
    @professors = Professor.find(:all, :conditions => ["desligado = 0"], :order => "matricula ASC")
  end

  def load_professors1
    @professors1 = Professor.find(:all, :conditions => ["desligado = 0"], :order => "nome ASC")

    if (current_user.has_role?('admin') or current_user.has_role?('SEDUC') or current_user.has_role?('supervisao'))
   @professors11 =  Professor.all(:conditions => ['desligado = 0 and temporario = 0 '], :order => 'matricula ASC')
    else  
      @professors11 =  Professor.all(:conditions => ['sede_id = ' + current_user.unidade_id.to_s + ' or sede_id = 54 and desligado = 0  and temporario = 0 '], :order => 'matricula ASC')
    end  
  end

  def load_professors_consulta
    @professors_consulta = Professor.find(:all, :conditions => ["desligado = 0"], :order => "nome ASC")
  end

def lista_professor
        #$teacher = params[:professor_professor_id]
        session[:teacher] = params[:professor_professor_id]
        @professor= Professor.find(:all,:conditions => ["id = ?",session[:teacher]])
        @tp = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (session[:teacher]).to_s + " and t.tipo = 'PERMANENTE'")
        @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (session[:teacher]).to_s + " and t.tipo = 'ANUAL'")
        render :update do |page|

          page.replace_html 'titulos', :partial => 'mostrar_pont_titulos'
        end
  end



  def professor_unidade
    if current_user.unidade_id == 53 or current_user.unidade_id == 52 then
      @professor_sede = Professor.all(:conditions => ['desligado = 0'], :order => 'matricula')
    else
      @professor_sede = Professor.all(:conditions => ['(sede_id = ' + current_user.unidade_id.to_s + ' or sede_id = 54) and desligado = 0'], :order => 'matricula')
    end
  end

  def load_consulta_ano
    @ano = TituloProfessor.find(:all,:select => 'distinct(ano_letivo) as ano',:order => 'ano_letivo DESC')
 
  end

end