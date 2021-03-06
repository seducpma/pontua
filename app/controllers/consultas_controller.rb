class ConsultasController < ApplicationController
before_filter :sede_unidade
before_filter :load_titulos
layout :define_layout
helper_method :sort_column, :sort_direction
  def define_layout
      current_user.layout
  end

  def index
  end


  def search
  end

  def consulta_geral
  $tipo_con = 10
  #@professor_rel_geral = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0", (Time.now.year)], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
  @professor_rel_geral = Professor.find(:all, :conditions=> ["desligado = 0"], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
  end

  def consulta_funcao
    w=session[:funcao] =  params[:search]
    t=0
    if session[:funcao].nil?
      @professor_consulta_funcao=nil
    else
       if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
             if session[:funcao] == 'ADI / Prof. de Creche'
                #@professor_consulta_funcao = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.funcao2 = 'ADI / Prof. de Creche'", Time.current.strftime("%Y").to_i,], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                @professor_consulta_funcao = Professor.find(:all, :conditions=> ["desligado = 0 and funcao2 = 'ADI / Prof. de Creche'" ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
             else
                #@professor_consulta_funcao = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.funcao like ?", Time.current.strftime("%Y").to_i, session[:funcao]], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                 @professor_consulta_funcao = Professor.find(:all, :conditions=> ["desligado = 0 and funcao like ?",  session[:funcao]], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
             end
      else
             if session[:funcao] == 'ADI / Prof. de Creche'
                #@professor_consulta_funcao = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.funcao2 = 'ADI / Prof. de Creche'", Time.current.strftime("%Y").to_i,], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                @professor_consulta_funcao = Professor.find(:all, :conditions=> ["desligado = 0 and funcao2 = 'ADI / Prof. de Creche'" ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
             else
                #@professor_consulta_funcao = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.funcao like ?", Time.current.strftime("%Y").to_i, session[:funcao]], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                 @professor_consulta_funcao = Professor.find(:all, :conditions=> ["desligado = 0 and funcao like ?",  session[:funcao]], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
             end

       end
    end
      render :action => 'consulta_funcao'


  end

  def consulta_unidade
    session[:uni] = params[:search]
    if session[:uni].nil?
      @professor_consulta_unidade=nil
    else
       if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
            #@professor_consulta_unidade = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.sede_id = ?", Time.current.strftime("%Y").to_i, session[:uni] ], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
             @professor_consulta_unidade = Professor.find(:all, :conditions=> ["desligado = 0 and sede_id = ?", session[:uni] ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
      else
             #@professor_consulta_unidade = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.sede_id = ? and (professors.sede_id = ? or sede_id = 54)" , Time.current.strftime("%Y").to_i, session[:uni], current_user.unidade_id ], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
              @professor_consulta_unidade = Professor.find(:all, :conditions=> ["desligado = 0 and sede_id = ? and (sede_id = ? or sede_id = 54)" , session[:uni], current_user.unidade_id ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
       end
    end
      render :action => 'consulta_unidade'
  end



  def consulta_unidade_funcao

    w1=session[:uni] = params[:unidade]
    w2=session[:funcao] = params[:funcao]
    if session[:uni].nil?
       @professor_consulta_unidade_funcao=nil
    else
       if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
             if session[:funcao] == 'ADI / Prof. de Creche'
                 @professor_consulta_unidade_funcao = Professor.find(:all, :conditions=> ["desligado = 0 and sede_id = ? and funcao2  like?",  session[:uni], session[:funcao]  ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
             else
                  @professor_consulta_unidade_funcao = Professor.find(:all, :conditions=> ["desligado = 0 and sede_id = ? and funcao  like?",  session[:uni], session[:funcao]  ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
             end
      else
             if session[:funcao] == 'ADI / Prof. de Creche'
                 @professor_consulta_unidade_funcao = Professor.find(:all, :conditions=> ["desligado = 0 and sede_id = ? and funcao2  like?",  session[:uni], session[:funcao]  ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                 t=0
             else
                 @professor_consulta_unidade_funcao = Professor.find(:all, :conditions=> ["desligado = 0 and sede_id = ? and funcao  like?",  session[:uni], session[:funcao]  ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                 t=0
             end

       end
    end
      render :action => 'consulta_unidade_funcao'
  end



    def relatorio_por_funcao
    @search = Professor.search(params[:search])
    if (params[:search]).present?
      @relatorio_funcao = @search.paginate(:all,:page=>params[:page],:per_page =>20, :order => sort_column + " " + sort_direction)
   else
      @relatorio_funcao = "Selecione uma função"
   end
    render :action => 'relatorio_por_funcao'
  end

  def consulta_ppu
    $tipo_con = 1
    $v = 1
  end

 def consulta_pu
    $tipo_con = 2
    $v = 1
    render :update do |page|
      page.replace_html 'tempo', :text => ''
      page.replace_html 'principal', :partial => 'consultas'
    end
 end

 def consulta_sede
    $sede = params[:p_sede_id]
    if $sede == 54 then
      $sede= 'TODAS UNIDADES'
    else
      @professors = Professor.find_all_by_sede_id($sede)
      @professors = Professor.find(:all,:conditions => ['sede_id = ?',$sede])
      $professor = Professor.find_all_by_sede_id($sede).object_id

    end
  if $tipo_con == 1 then
   if $sede == 'TODAS UNIDADES' then
      @professorsnome = Professor.find(:all, :order => 'nome')
    else
     if $sede == 'SELECIONE' then
       @professorsnome = ''
     else
        @professorsnome = Professor.find(:all, :conditions => ['sede_id = ?',$sede], :order => 'nome')
     end
    end
      render :update do |page|
        page.replace_html 'professores', :partial => 'professor_sede'
      end

  else
   if $tipo_con == 2 then
    if $sede == 'TODAS UNIDADES' then
      @professorsnome = Professor.find(:all, :order => 'pontuacao_final DESC')
    else
     if $sede == 'SELECIONE' then
       @professorsnome = ''
     else
      @professorsnome = Professor.find(:all,:conditions => ['sede_id = ?',$sede], :order => 'pontuacao_final DESC')
     end
    end

    render :update do |page|
      page.replace_html 'consultas', :partial => 'lista_consulta_sede'
      page.replace_html 'tempo', :text => ''
      page.replace_html 'nome_consulta', :text => 'Pontuação Professores por Unidade'
    end

   else
   if $tipo_con == 4 then
   if $sede == 'TODAS UNIDADES' then
      @professorsnome = Professor.find(:all, :order => 'nome')
    else
     if $sede == 'SELECIONE' then
       @professorsnome = ''
     else
        @professorsnome = Professor.find(:all,:conditions => ['sede_id = ?',$sede], :order => 'nome')
     end
    end
      render :update do |page|
        page.replace_html 'professores', :partial => 'busca_titulacao'
      end
    end
   end
  end
 end

  def consulta_nome
    $professor = params[:pro_professor_id]    
   if $professor.empty? then
    render :update do |page|
      page.replace_html 'tempo', :text => ''
      page.replace_html 'consultas', :text => ''
    end
    else
    if logged_in?
        
        if current_user.unidade_id == 53 or current_user.unidade_id == 52 then
         @professors = TituloProfessor.professor_current(params[:pro_professor_id])
        else
         @professor = TituloProfessor.professor_normal(params[:pro_professor_id])
        end
    end
    @tp = TituloProfessor.titulo_permanente(params[:pro_professor_id])
    @tp1 = TituloProfessor.titulo_permanente(params[:pro_professor_id])
    render :update do |page|
      page.replace_html 'consultas', :partial => 'lista_consulta_nomeprofessor'
      page.replace_html 'tempo', :text => ''
      page.replace_html 'nome_consulta', :text => 'Pontuação Professor'
    end
    end
 end

 def consulta_pt
  $tipo_con = 4
  render :update do |page|
    page.replace_html 'tempo', :text => ''
    page.replace_html 'principal', :partial => 'busca_titulacao'
  end
 end

 def consulta_titulo
   if (params[:search].nil? || params[:search].empty?)
      titulo = 0
      $titulo = 0
   else
      titulo = params[:search][:search]
      $titulo = params[:search][:search].to_s
   end
    if $titulo != 0
     if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
      if (params[:search][:search] == 1 or params[:search][:search] == 2 or params[:search][:search] == 3 or params[:search][:search] == 4 or params[:search][:search] == 5) then
        @professors = Professor.find(:all,:joins => :titulo_professors, :conditions =>['titulo_professors.titulo_id = ?', $titulo],:select => "DISTINCT professors.*")
      else
        @professors = Professor.find(:all,:joins => :titulo_professors, :conditions =>['titulo_professors.titulo_id = ? and titulo_professors.ano_letivo = ?', $titulo,$data],:select => "DISTINCT professors.*")
      end
     else
       if (params[:search][:search] == 1 or params[:search][:search] == 2 or params[:search][:search] == 3 or params[:search][:search] == 4 or params[:search][:search] == 5) then
         @professors = TituloProfessor.professor_consulta_titulo_permanente(params[:search][:search],current_user)
       else
         @professors = TituloProfessor.professor_consulta_titulo_anual(params[:search][:search],current_user,$data)
       end
     end
         @professors = Professor.find(:all,:joins => :titulo_professors, :conditions =>['titulo_professors.titulo_id = ?', $titulo],:select => "DISTINCT professors.*")
         #@professors = Professor.paginate(:all,:joins => :titulo_professors, :conditions =>['titulo_professors.titulo_id = ? and titulo_professors.ano_letivo = ?', $titulo,$data]
         #@professors = TituloProfessor.find(:all, :conditions => ['titulo_id=?',$titulo.to_s])
    end
  end

 
 def impressao_geral
        session[:tipo_con] = 10
        if (session[:tipoclassificacao]== 'CLASSIFICACÃO GERAL')
         #@professor_impressao = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0", Time.current.strftime("%Y").to_i], :order => 'tempo_servicos.pontuacao_geral DESC')
          @professor_impressao = Professor.find(:all, :conditions=> ["desligado = 0" ], :order => 'pontuacao_final DESC')
        else if (session[:tipoclassificacao] == 'CLASSIFICACÃO P/ FUNÇÃO')

                 if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                         if session[:funcao] == 'ADI / Prof. de Creche'
                               #@professor_impressao = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.funcao2 = 'ADI / Prof. de Creche'", Time.current.strftime("%Y").to_i,], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                                @professor_impressao = Professor.find(:all, :conditions=> ["desligado = 0 and professors.funcao2 = 'ADI / Prof. de Creche'",], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                         else 
                            #@professor_impressao = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.funcao like ?", Time.current.strftime("%Y").to_i, session[:funcao]], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                             @professor_impressao = Professor.find(:all,:conditions=> ["desligado = 0 and funcao like ?",  session[:funcao]], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                         end
                  else
                         #@professor_impressao = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.funcao like ? and (professors.sede_id = ? or sede_id = 54)" , Time.current.strftime("%Y").to_i, session[:funcao], current_user.unidade_id ], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                          @professor_impressao = Professor.find(:all, :conditions=> ["desligado = 0 and funcao like ? and (sede_id = ? or sede_id = 54)" ,  session[:funcao], current_user.unidade_id ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                          t=0
                   end
             else if (session[:tipoclassificacao] == 'CLASSIFICACÃO P/ UNIDADE')
                         if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                           #@professor_impressao  = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.sede_id = ?", Time.current.strftime("%Y").to_i, $uni ], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                           @professor_impressao  = Professor.find(:all, :conditions=> ["desligado = 0 and sede_id = ?",  session[:uni] ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                         else
                           #@professor_impressao  = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.sede_id = ? and (professors.sede_id = ? or sede_id = 54)" , Time.current.strftime("%Y").to_i, $uni, current_user.unidade_id ], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                            @professor_impressao  = Professor.find(:all, :conditions=> ["desligado = 0 and sede_id = ? and (sede_id = ? or sede_id = 54)" ,  session[:uni], current_user.unidade_id ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                         end
                    else if (session[:tipoclassificacao] == 'CLASSIFICACÃO P/ UNIDADE-FUNÇÃO')
                            if (current_user.unidade_id == 53 or current_user.unidade_id == 52) then
                                 if session[:funcao] == 'ADI / Prof. de Creche'
                                   #@professor_impressao = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.sede_id = ? and professors.funcao2 = 'ADI / Prof. de Creche'", Time.current.strftime("%Y").to_i, $uni, ], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                                 w=session[:uni]
                                 t=0

                                    @professor_impressao = Professor.find(:all,:conditions=> ["desligado = 0 and sede_id = ? and funcao2 = 'ADI / Prof. de Creche'", session[:uni] ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                                 else
                                   #@professor_impressao = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.sede_id = ? and professors.funcao like ?", Time.current.strftime("%Y").to_i, $uni, session[:funcao] ], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                                    @professor_impressao = Professor.find(:all, :conditions=> ["desligado = 0 and sede_id = ? and funcao like ?",  session[:uni], session[:funcao] ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                                 end
                            else
                                #@professor_impressao = TempoServico.find(:all,:joins => :professor, :conditions=> ["tempo_servicos.ano_letivo = ? and professors.desligado = 0 and professors.sede_id = ? and professors.funcao like ? and (professors.sede_id = ? or sede_id = 54)", Time.current.strftime("%Y").to_i, $uni, session[:funcao], current_user.unidade_id ], :order => 'tempo_servicos.pontuacao_geral DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                                 @professor_impressao = Professor.find(:all, :conditions=> ["desligado = 0 and sede_id = ? and funcao like ? and (sede_id = ? or sede_id = 54)",  session[:uni], session[:funcao], current_user.unidade_id ], :order => 'pontuacao_final DESC,dt_ingresso DESC,dt_nasc,n_filhos DESC')
                            end
                      end
                  end
             end
        end


   render :layout => "impressao"
end
private

  def sort_column
    Professor.column_names.include?(params[:sort]) ? params[:sort] : "nome"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


 protected
  def sede_unidade
    if current_user.unidade_id == 53 or current_user.unidade_id == 52 then
      #@unidade_sede = Unidade.find(:all,  :select => 'distinct(unidades.nome)',:joins => "inner join professors on professors.sede_id = unidades.id",  :conditions=> ["professors.desligado = 0"], :order => 'nome ASC')
      @unidade_sede = Unidade.find(:all, :order => 'nome ASC')
    else
      #@unidade_sede = Unidade.find(:all,  :select => 'distinct(unidades.nome)',:joins => "inner join professors on professors.sede_id = unidades.id",  :conditions=> ["professors.desligado = 0 and (professors.sede_id = ? or sede_id = 54)", current_user.unidade_id ], :order => 'nome ASC')
      @unidade_sede = Unidade.find(:all , :order => 'nome ASC')
    end
  end

  def load_titulos
    @titulos = Titulacao.find(:all, :order => "descricao")
  end


end
