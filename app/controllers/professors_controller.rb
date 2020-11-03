class ProfessorsController < ApplicationController

before_filter :load_unidades
before_filter :load_professors
before_filter :load_consulta_ano

def sobre
  
end


def impressao
t=0
        @temposervico = TempoServico.find(:all,:conditions =>['professor_id = ? and ano_letivo = ?', session[:teacher1], session[:ano]])
        @professor= Professor.find(:all,:conditions => ["id = ? and desligado = 0",session[:teacher1]])
         @tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo between ? and ? and titulacaos.tipo = 'PERMANENTE'", session[:teacher1], 2009, session[:ano]] )
         @tp1 = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo = ? and titulacaos.tipo = 'ANUAL'", session[:teacher1], session[:ano]] )
      
      render :layout => "impressao"
end

  def load_unidades
     @cargos = Cargo.find(:all, :order=>'id ASC')
    if current_user.unidade_id == 53 or current_user.unidade_id == 52 then
      @unidades = Unidade.find(:all, :order => "nome")
    else
      @unidades = Unidade.find(:all,   :conditions => ["id = ? or id = 54", current_user.unidade_id ], :order => 'nome ASC')

    end
  end


  


  def load_professors
      @professors = Professor.find(:all, :order => 'nome ASC')
      @professors1 = Professor.find(:all, :order => 'matricula ASC')
      @professor_erros= Professor.find(:all,:conditions => ["desligado = 0"], :order => 'matricula ASC')
t=0
  end

  
  # GET /professors
  # GET /professors.xml
  def index
    @professors = Professor.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @professors }
    end
  end

  # GET /professors/1
  # GET /professors/1.xml


  def show
    @professor = Professor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @professor }
    end
  end

  # GET /professors/new
  # GET /professors/new.xml
  def new
    @professor = Professor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @professor }
    end
  end

  # GET /professors/1/edit
  def edit
    @professor = Professor.find(params[:id])

  end

  # POST /professors
  # POST /professors.xml
  def create
    @professor = Professor.new(params[:professor])

    respond_to do |format|
      if @professor.save
        flash[:notice] = 'SALVO COM SUCESSO.'
        format.html { redirect_to(@professor) }
        format.xml  { render :xml => @professor, :status => :created, :location => @professor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @professor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /professors/1
  # PUT /professors/1.xml
  def update
    @professor = Professor.find(params[:id])

    respond_to do |format|
      if @professor.update_attributes(params[:professor])
        flash[:notice] = 'SALVO COM SUCESSO.'
        format.html { redirect_to(@professor) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @professor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /professors/1
  # DELETE /professors/1.xml
  def destroy
    @professor = Professor.find(params[:id])
    @professor.destroy

    respond_to do |format|
      format.html { redirect_to(professors_url) }
      format.xml  { head :ok }
    end
  end

  def consulta_nome
    render 'consulta_nome'
  end

 def consultaprofessor

     if params[:type_of].to_i == 3
      session[:tipo] = 3
      if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
          @professors = Professor.find(:all,:order => 'nome ASC')
      else
          @professors = Professor.find(:all, :conditions=> ["(sede_id = ? or sede_id = 54)" , current_user.unidade_id] ,:order => 'sede_id,nome ASC ')
      end
     render :update do |page|
         page.replace_html 'professores', :partial => "professores"
       end
     end
     if params[:type_of].to_i == 2
       session[:tipo] = 2
      if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
          @professors = Professor.find(:all, :conditions=> ["desligado = 0"],:order => 'nome ASC')
      else
          @professors = Professor.find(:all, :conditions=> ["desligado = 0 and (sede_id = ? or sede_id = 54)" , current_user.unidade_id], :order => 'sede_id, nome ASC')
      end
      render :update do |page|
        page.replace_html 'professores', :partial => "professores"
       end
     end
     if params[:type_of].to_i == 4
       session[:tipo] = 4
       if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
          @professors = Professor.find(:all, :conditions=> ["desligado = 1"],:order => 'nome ASC')
      else
          @professors = Professor.find(:all, :conditions=> ["desligado = 1 and (sede_id = ? or sede_id = 54)" , current_user.unidade_id], :order => 'sede_id, nome ASC')
      end
       render :update do |page|
        page.replace_html 'professores', :partial => "professores"
        end
     end
      if params[:type_of].to_i == 1
        session[:tipo] = 1
        session[:nome] = params[:search1].to_s
         if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
             @professors = Professor.find(:all,:conditions => ["nome like ?", "%" + params[:search1].to_s + "%"],:order => 'nome ASC')
         else
             @professors = Professor.find(:all, :conditions=> ["nome like ? and (sede_id = ? or sede_id = 54)" ,"%" + params[:search1].to_s + "%", current_user.unidade_id], :order => 'sede_id,nome ASC')
         end
          render :update do |page|
                page.replace_html 'professores', :partial => "professores"
              end
       end
       if params[:type_of].to_i == 5
         session[:tipo] = 5
              render :update do |page|
                page.replace_html 'professores', :partial => "professores"
              end
       end
       if params[:type_of].to_i == 6
         session[:tipo] = 6
         session[:tipo_prof] = params[:search].to_s
         if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
             @professors = Professor.find( :all,:conditions => ["funcao like ? AND desligado= 0 ", "%" + params[:search].to_s + "%" ],:order => 'nome ASC')
         else
             @professors = Professor.find(:all, :conditions=> ["desligado = 0 and funcao like ? and (sede_id = ? or sede_id = 54)" ,"%" + params[:search].to_s + "%", current_user.unidade_id], :order => 'sede_id,nome ASC')
         end
         render :update do |page|
                page.replace_html 'professores', :partial => "professores"
         end
       end



end


 def impressao_consulta

     if session[:tipo] == 3
       t=0
      if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
          @professors = Professor.find(:all,:order => 'nome ASC')
      else
          @professors = Professor.find(:all, :conditions=> ["(sede_id = ? or sede_id = 54)" , current_user.unidade_id] ,:order => 'sede_id,nome ASC ')
      end
     end
     if session[:tipo] == 2
       t=0
      if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
          @professors = Professor.find(:all, :conditions=> ["desligado = 0"],:order => 'nome ASC')
      else
          @professors = Professor.find(:all, :conditions=> ["desligado = 0 and (sede_id = ? or sede_id = 54)" , current_user.unidade_id], :order => 'sede_id, nome ASC')
      end
     end
     if session[:tipo] == 4
              t=0
       if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
          @professors = Professor.find(:all, :conditions=> ["desligado = 1"],:order => 'nome ASC')
      else
          @professors = Professor.find(:all, :conditions=> ["desligado = 1 and (sede_id = ? or sede_id = 54)" , current_user.unidade_id], :order => 'sede_id, nome ASC')
      end
     end
      if session[:tipo] == 1
       t=0
         if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
             @professors = Professor.find(:all,:conditions => ["nome like ?", "%" + session[:nome] + "%"],:order => 'nome ASC')
             t=0
         else
             @professors = Professor.find(:all, :conditions=> ["nome like ? and (sede_id = ? or sede_id = 54)" ,"%" + params[:search1].to_s + "%", current_user.unidade_id], :order => 'sede_id,nome ASC')
          t=0
         end
       end
       if session[:tipo]== 5
          @professors = Professor.find(:all, :conditions => ['sede_id=? AND DESLIGADO = 0', session[:unidade_id]], :order => 'nome ASC')

       end
       if session[:tipo] == 6
         if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
             @professors = Professor.find( :all,:conditions => ["funcao like ? AND desligado= 0 ", "%" + session[:tipo_prof] + "%" ],:order => 'nome ASC')
         else
             @professors = Professor.find(:all, :conditions=> ["desligado = 0 and funcao like ? and (sede_id = ? or sede_id = 54)" ,"%" + session[:tipo_prof] + "%", current_user.unidade_id], :order => 'sede_id,nome ASC')
         end
       end

      render :layout => "impressao"
end




 
  def lista_professor_unidade
    $sede = params[:unidade_id]
    session[:unidade_id]= params[:unidade_id]
    session[:tipo]= 5
    #@professors = Professor.find(:all, :conditions => ['sede_id=' + $sede])
    @professors = Professor.find(:all, :conditions => ['sede_id=? AND DESLIGADO = 0', params[:unidade_id]], :order => 'nome ASC')

    render :partial => 'professores'
  end

def consulta_ficha_pontuacao
     session[:teacher1] = params[:consulta][:professor_id]
     session[:ano] = params[:ano_letivo]
     $ANO_ANO = session[:ano]
     $TEACHER_TEACHER = session[:teacher1]
     w1=session[:ano]
        @temposervico = TempoServico.find(:all,:conditions =>['professor_id = ? and ano_letivo = ?', session[:teacher1], session[:ano]])
        @professor= Professor.find(:all,:conditions => ["id = ? and desligado = 0",session[:teacher1]])
         @tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo between ? and ? and titulacaos.tipo = 'PERMANENTE'", session[:teacher1], 2009, session[:ano] ])
         @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (session[:teacher1]).to_s + " and t.tipo = 'ANUAL'and ano_letivo ="+session[:ano])

           render :update do |page|

          page.replace_html 'titulos', :partial => 'mostrar_pontuacao'
        end
end


def load_consulta_ano
    @ano = TituloProfessor.find(:all,:select => 'distinct(ano_letivo) as ano',:order => 'ano_letivo DESC')
    @ano1 = TituloProfessor.find(:all,:select => 'distinct(ano_letivo) as ano', :conditions => ["ano_letivo > 2014"], :order => 'ano_letivo DESC')
  end

def consulta_ficha

@tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo = ? and titulacaos.tipo = 'ANUAL'", $teacher,session[:ano]] )
end




def altera_tabelas
@professor_alteracao = Professor.find(:all,:conditions => ["id = ? and desligado = 0",session[:teacher1]])
for professor in @professor_alteracao
  professor.pontuacao_final = session[:pontos]
  professor.save
end
 @temposervico_alteracao = TempoServico.find(:all,:conditions =>['professor_id = ? and ano_letivo = ?', session[:teacher1], session[:ano]])
for ts in @temposervico_alteracao
  ts.pontuacao_geral = session[:pontos]
  ts.save
  t=0
end
end

def acerta_tabelas
 t=0
end


def acertar_tabelas

  @professor = Professor.find(:all,:conditions => ["desligado = 0"])
cont=0
  for professor in @professor
    @serviço= TempoServico.find(:last, :conditions => ['professor_id=?', professor.id])
    @titulos = TituloProfessor.find(:last, :conditions => ['professor_id=?' , professor.id])
    t=0

   if @serviço.present?
      professor.total_trabalhado = @serviço.total_geral_tempo_servico
    else
      professor.total_trabalhado =   0
    end
    if @titulos.present?
       #professor.total_titulacao =   @titulos.total_titulacao
        professor.total_titulacao =   professor.pontuacao_final -  professor.total_trabalhado
    else
      professor.total_titulacao =   0
    end
   professor.save
 end
  render :update do |page|
     page.replace_html 'OK', :text => 'TABELAS EQUALIZADAS'
  end


end

def corrigir_totalizacao_tabelas # acerta totalização na tabela de professor e tempo_servico
   @professor = Professor.find(params[:id])

      prof_id= @professor.id
      subtotal_titulos = 0
      permanente= 0
      anual = 0
      pontos = 0
      session[:pontos_anterior]= professor_pontuacao_final = @professor.pontuacao_final
      t=0
       @temposervico = TempoServico.find(:all,:conditions =>['professor_id = ? and ano_letivo = ?', @professor.id, Time.now.year],:readonly => false)
       @tp = TituloProfessor.all(:joins => "inner join titulacaos on titulo_professors.titulo_id = titulacaos.id", :conditions =>["titulo_professors.professor_id =? and ano_letivo between ? and ? and titulacaos.tipo = 'PERMANENTE'", @professor.id, 2009, Time.now.year ])
       @tp1 = TituloProfessor.find_by_sql("SELECT * FROM titulo_professors tp inner join titulacaos t on tp.titulo_id=t.id where tp.professor_id=" + (@professor.id).to_s + " and t.tipo = 'ANUAL'and ano_letivo ="+Time.now.year.to_s)
        for temposervico in @temposervico
           tempo_servico= temposervico.total_geral_tempo_servico
           total_tempo_servico= temposervico.pontuacao_geral
           ano_letivo = temposervico.ano_letivo
            if !((@tp.nil?) or (@tp.empty?))
               for tp in @tp
                  permanente = tp.total_permanente
               end
            end
           for tp1 in @tp1
               ano = tp1.ano_letivo
               anual =   tp1.totaliza_anual(tp1.professor_id)
            end
       end
        subtotal_titulos = permanente + anual
        pontos= subtotal_titulos + tempo_servico
        t=0
        if ((professor_pontuacao_final!=pontos) or (total_tempo_servico!= pontos))and (ano_letivo > 2015)

           professor_pontuacao_final = @professor.pontuacao_final

             #  PONTUAÇÂO TEMPO SERVIÇO #
           @temposervico = TempoServico.find(:all,:conditions =>['professor_id = ? and ano_letivo = ?', @professor.id, Time.now.year],:readonly => false)

           for temposervico in @temposervico
                  subtotal1= temposervico.dias_trab2 + temposervico.dias_trab1
                  subtotal2= temposervico.dias_efetivos2 + temposervico.dias_efetivos1
                  subtotal3= temposervico.dias_rede2 + temposervico.dias_rede1
                  if (Time.current.strftime("%Y").to_i)< (Time.now.year)
                        subtotal4= temposervico.dias_unidade2 + temposervico.dias_unidade1
                  end
                      tempo_servico= temposervico.total_geral_tempo_servico
                      ano_letivo = temposervico.ano_letivo

             # PONTUAÇÂO TITULAÇÂO -->
              subtotal_titulos = 0
              if !((@tp.nil?) or (@tp.empty?))
                for tp in @tp
                   permanente = tp.total_permanente
                 end
               end
              for tp1 in @tp1
              ano = tp1.ano_letivo
              anual =   tp1.totaliza_anual(tp1.professor_id)
              end
              subtotal_titulos = permanente + anual

              session[:pontos_correcao]= pontos = subtotal_titulos +tempo_servico
              t=0

@professor.pontuacao_final = pontos
@professor.save
t=0
 @temposervico[0].pontuacao_geral = pontos
 @temposervico[0].save
      t=0
       end


 end




end
end
