class RelatoriosController < ApplicationController
  # GET /relatorios
  # GET /relatorios.xml

   before_filter :load_obreiros
   before_filter :load_unidades
   before_filter :load_relatorios_ano

 def load_unidades
      if (current_user.unidade_id==9999)
          @unidades = Unidade.find(:all, :order => 'nome ASC')
       else if (current_user.obreiro_id == nil)
            @unidades = Unidade.find(:all,:conditions => ["id = ?", current_user.unidade_id], :order => 'nome ASC')
            else if (current_user.unidade_id ==  nil)
                  @unidades = Unidade.find(:all,:conditions => ["obreiro_id = ?", current_user.obreiro_id], :order => 'nome ASC')
                  end
             end
       end
  end

  def load_obreiros
      if (current_user.unidade_id==9999)
         @obreiros = Obreiro.find(:all, :order => 'nome ASC')
       else if (current_user.obreiro_id == nil)
            @obreiros = Obreiro.find(:all,:include => [:unidades],:conditions => ["unidades.id = ?", current_user.unidade_id])
            else if (current_user.unidade_id ==  nil)
                  @obreiros = Obreiro.find(:all, :include => [:unidades], :conditions => ["unidades.obreiro_id = ?", current_user.obreiro_id])
                  end
            end
       end
  end

  def load_relatorios_ano
      @rel_ano = Relatorio.find(:all,:select => 'distinct year(data) as ano',:order => 'data DESC')
  end



  def index
    @relatorios = Relatorio.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @relatorios }
    end
  end

  # GET /relatorios/1
  # GET /relatorios/1.xml
  def show
    @relatorio = Relatorio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @relatorio }
    end
  end

  # GET /relatorios/new
  # GET /relatorios/new.xml
  def new
    @relatorio = Relatorio.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @relatorio }
    end
  end

  # GET /relatorios/1/edit
  def edit
    @relatorio = Relatorio.find(params[:id])
  end

  # POST /relatorios
  # POST /relatorios.xml
  def create
    @relatorio = Relatorio.new(params[:relatorio])

    respond_to do |format|
      if @relatorio.save
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@relatorio) }
        format.xml  { render :xml => @relatorio, :status => :created, :location => @relatorio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @relatorio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /relatorios/1
  # PUT /relatorios/1.xml
  def update
    @relatorio = Relatorio.find(params[:id])

    respond_to do |format|
      if @relatorio.update_attributes(params[:relatorio])
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
        format.html { redirect_to(@relatorio) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @relatorio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /relatorios/1
  # DELETE /relatorios/1.xml
  def destroy
    @relatorio = Relatorio.find(params[:id])
    @relatorio.destroy

    respond_to do |format|
      format.html { redirect_to(relatorios_url) }
      format.xml  { head :ok }
    end
  end


  def consultarelatorio
     session[:type] = params[:type_of]
     session[:unidade]= params[:relatorio][:unidade_id]
     session[:obreiro]= params[:relatorio][:obreiro_id]
     session[:mese] = params[:mes_e]
     session[:meso]= params[:mes_o]
     session[:anoe] = params[:ano_e]
     session[:anoo] = params[:ano_o]

     unless params[:search].present?
     if params[:type_of].to_i == 6
           if (current_user.unidade_id==9999)
                @relatorios = Relatorio.paginate(:all, :page => params[:page], :per_page => 50,:order => 'created_at DESC')
            else if (current_user.obreiro_id == nil)
                    @relatorios = Relatorio.find(:all,:include => [:unidade],:conditions => ["unidades.id = ?", current_user.unidade_id], :order => 'relatorios.created_at DESC')
                    else if (current_user.unidade_id ==  nil)
                           @relatorios = Relatorio.find(:all,:include => [:unidade],:conditions => ["unidades.obreiro_id = ?", current_user.obreiro_id], :order => 'relatorios.created_at DESC')
                        end
                    end
             end
        render :update do |page|
           page.replace_html 'relatorio', :partial => "relatorios"
       end
     end
   else if params[:type_of].to_i == 1
          if (params[:mes_e]== 'JANEIRO')
             ano =params[:ano_e]
             inicio = "#{Time.now.strftime("%Y")}-01-01 00:00:00"
             fim = "#{Time.now.strftime("%Y")}-01-31 23:59:59"
             @relatorios = Relatorio.find(:all, :include => [:unidade], :conditions => ["relatorios.unidade_id=?  and unidades.id = ? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:unidade_id], current_user.unidade_id], :order => 'created_at DESC')
             render :update do |page|
               page.replace_html 'relatorio', :partial => "relatorios"
             end
          else if(params[:mes_e]== 'FEVEREIRO')
                  ano =params[:ano_e]
                  $mes = params[:mes_e]
                  inicio = "#{ano}-02-01 00:00:00"
                  fim = "#{ano}-02-28 23:59:59"
                   @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:unidade_id]],:order => 'created_at DESC')
                   render :update do |page|
                      page.replace_html 'relatorio', :partial => "relatorios"
                   end
               else if(params[:mes_e]== 'MARÇO')
                      ano =params[:ano_e]
                      inicio = "#{Time.now.strftime("%Y")}-03-01 00:00:00"
                      fim = "#{Time.now.strftime("%Y")}-03-31 23:59:59"
                      @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:unidade_id]],:order => 'created_at DESC')
                      render :update do |page|
                        page.replace_html 'relatorio', :partial => "relatorios"
                       end
                   else if(params[:mes_e]== 'ABRIL')
                          ano =params[:ano_e]
                          inicio = "#{Time.now.strftime("%Y")}-04-01 00:00:00"
                          fim = "#{Time.now.strftime("%Y")}-04-30 23:59:59"
                           @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:unidade_id]],:order => 'created_at DESC')
                           render :update do |page|
                             page.replace_html 'relatorio', :partial => "relatorios"
                           end
                         else if(params[:mes_e]== 'MAIO')
                               ano =params[:ano_e]
                               inicio = "#{Time.now.strftime("%Y")}-05-01 00:00:00"
                               fim = "#{Time.now.strftime("%Y")}-05-31 23:59:59"
                               @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:unidade_id]],:order => 'created_at DESC')
                               render :update do |page|
                                  page.replace_html 'relatorio', :partial => "relatorios"
                               end
                              else if(params[:mes_e]== 'JUNHO')
                                    ano =params[:ano_e]
                                    inicio = "#{Time.now.strftime("%Y")}-06-01 00:00:00"
                                    fim = "#{Time.now.strftime("%Y")}-06-30 23:59:59"
                                     @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:unidade_id]],:order => 'created_at DESC')
                                     render :update do |page|
                                        page.replace_html 'relatorio', :partial => "relatorios"
                                     end
                                   else if(params[:mes_e]== 'JULHO')
                                          ano =params[:ano_e]
                                          inicio = "#{Time.now.strftime("%Y")}-07-01 00:00:00"
                                          fim = "#{Time.now.strftime("%Y")}-07-31 23:59:59"
                                           @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:unidade_id]],:order => 'created_at DESC')
                                           render :update do |page|
                                              page.replace_html 'relatorio', :partial => "relatorios"
                                           end
                                         else if(params[:mes_e]== 'AGOSTO')
                                                ano =params[:ano_e]
                                                inicio = "#{Time.now.strftime("%Y")}-08-01 00:00:00"
                                                fim = "#{Time.now.strftime("%Y")}-08-31 23:59:59"
                                                @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:unidade_id]],:order => 'created_at DESC')
                                                render :update do |page|
                                                     page.replace_html 'relatorio', :partial => "relatorios"
                                                end
                                              else if(params[:mes_e]== 'SETEMBRO')
                                                     ano =params[:ano_e]
                                                     inicio = "#{Time.now.strftime("%Y")}-09-01 00:00:00"
                                                     fim = "#{Time.now.strftime("%Y")}-09-30 23:59:59"
                                                     @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')",params[:relatorio][:unidade_id]],:order => 'created_at DESC')
                                                     render :update do |page|
                                                       page.replace_html 'relatorio', :partial => "relatorios"
                                                     end
                                                    else if(params[:mes_e]== 'OUTUBRO')
                                                           ano =params[:ano_e]
                                                           inicio = "#{Time.now.strftime("%Y")}-10-01 00:00:00"
                                                           fim = "#{Time.now.strftime("%Y")}-10-31 23:59:59"
                                                           @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')",params[:relatorio][:unidade_id]],:order => 'created_at DESC')
                                                           render :update do |page|
                                                             page.replace_html 'relatorio', :partial => "relatorios"
                                                           end
                                                         else if(params[:mes_e]== 'NOVEMBRO')
                                                                ano =params[:ano_e]
                                                                 inicio = "#{Time.now.strftime("%Y")}-11-01 00:00:00"
                                                                 fim = "#{Time.now.strftime("%Y")}-11-30 23:59:59"
                                                                 @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:unidade_id]],:order => 'created_at DESC')
                                                                 render :update do |page|
                                                                      page.replace_html 'relatorio', :partial => "relatorios"
                                                                 end
                                                              else if(params[:mes_e]== 'DEZEMBRO')
                                                                     ano =params[:ano_e]
                                                                     inicio = "#{Time.now.strftime("%Y")}-012-01 00:00:00"
                                                                     fim = "#{Time.now.strftime("%Y")}-12-31 23:59:59"
                                                                     @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:unidade_id]],:order => 'created_at DESC')
                                                                     render :update do |page|
                                                                         page.replace_html 'relatorio', :partial => "relatorios"
                                                                     end
                                                                   end
                                                              end
                                                         end
                                                   end
                                              end
                                        end
                                   end
                              end
                         end
                    end
               end
          end
    else if params[:type_of].to_i == 2
          if (params[:mes_o]== 'JANEIRO')
             ano =params[:ano_o             ]
             inicio = "#{Time.now.strftime("%Y")}-01-01 00:00:00"
             fim = "#{Time.now.strftime("%Y")}-01-31 23:59:59"
             @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
             render :update do |page|
               page.replace_html 'relatorio', :partial => "relatorios"
             end
          else if(params[:mes_o]== 'FEVEREIRO')
                  ano =params[:ano_o]
                  inicio = "#{ano}-02-01 00:00:00"
                  fim = "#{ano}-02-28 23:59:59"
                   @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                   render :update do |page|
                      page.replace_html 'relatorio', :partial => "relatorios"
                   end
               else if(params[:mes_o]== 'MARÇO')
                      ano =params[:ano_o]
                      inicio = "#{Time.now.strftime("%Y")}-03-01 00:00:00"
                      fim = "#{Time.now.strftime("%Y")}-03-31 23:59:59"
                      @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                      render :update do |page|
                        page.replace_html 'relatorio', :partial => "relatorios"
                       end
                   else if(params[:mes_o]== 'ABRIL')
                          ano =params[:ano_o]
                          inicio = "#{Time.now.strftime("%Y")}-04-01 00:00:00"
                          fim = "#{Time.now.strftime("%Y")}-04-30 23:59:59"
                           @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                           render :update do |page|
                             page.replace_html 'relatorio', :partial => "relatorios"
                           end
                         else if(params[:mes_o]== 'MAIO')
                               ano =params[:ano_o]
                               inicio = "#{Time.now.strftime("%Y")}-05-01 00:00:00"
                               fim = "#{Time.now.strftime("%Y")}-05-31 23:59:59"
                               @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                               render :update do |page|
                                  page.replace_html 'relatorio', :partial => "relatorios"
                               end
                              else if(params[:mes_o]== 'JUNHO')
                                    ano =params[:ano_o]
                                    inicio = "#{Time.now.strftime("%Y")}-06-01 00:00:00"
                                    fim = "#{Time.now.strftime("%Y")}-06-30 23:59:59"
                                     @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                     render :update do |page|
                                        page.replace_html 'relatorio', :partial => "relatorios"
                                     end
                                   else if(params[:mes_o]== 'JULHO')
                                          ano =params[:ano_o]
                                          inicio = "#{Time.now.strftime("%Y")}-07-01 00:00:00"
                                          fim = "#{Time.now.strftime("%Y")}-07-31 23:59:59"
                                           @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')",params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                           render :update do |page|
                                              page.replace_html 'relatorio', :partial => "relatorios"
                                           end
                                         else if(params[:mes_o]== 'AGOSTO')
                                                ano =params[:ano_o]
                                                inicio = "#{Time.now.strftime("%Y")}-08-01 00:00:00"
                                                fim = "#{Time.now.strftime("%Y")}-08-31 23:59:59"
                                                @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                                render :update do |page|
                                                     page.replace_html 'relatorio', :partial => "relatorios"
                                                end
                                              else if(params[:mes_o]== 'SETEMBRO')
                                                     ano =params[:ano_o]
                                                     inicio = "#{Time.now.strftime("%Y")}-09-01 00:00:00"
                                                     fim = "#{Time.now.strftime("%Y")}-09-30 23:59:59"
                                                     @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                                     render :update do |page|
                                                       page.replace_html 'relatorio', :partial => "relatorios"
                                                     end
                                                    else if(params[:mes_o]== 'OUTUBRO')
                                                           ano =params[:ano_o]
                                                           inicio = "#{Time.now.strftime("%Y")}-10-01 00:00:00"
                                                           fim = "#{Time.now.strftime("%Y")}-10-31 23:59:59"
                                                           @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                                           render :update do |page|
                                                             page.replace_html 'relatorio', :partial => "relatorios"
                                                           end
                                                         else if(params[:mes_o]== 'NOVEMBRO')
                                                                ano =params[:ano_o]
                                                                 inicio = "#{Time.now.strftime("%Y")}-11-01 00:00:00"
                                                                 fim = "#{Time.now.strftime("%Y")}-11-30 23:59:59"
                                                                 @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                                                 render :update do |page|
                                                                      page.replace_html 'relatorio', :partial => "relatorios"
                                                                 end
                                                              else if(params[:mes_o]== 'DEZEMBRO')
                                                                     ano =params[:ano_o]
                                                                     inicio = "#{Time.now.strftime("%Y")}-012-01 00:00:00"
                                                                     fim = "#{Time.now.strftime("%Y")}-12-31 23:59:59"
                                                                     @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                                                     render :update do |page|
                                                                         page.replace_html 'relatorio', :partial => "relatorios"
                                                                     end
                                                                   end
                                                              end
                                                         end
                                                   end
                                              end
                                        end
                                   end
                              end
                         end
                    end
               end
          end
         end
      end
    end
  end





 def lista_unidade_obreiro
    $obreiro = params[:relatorio_obreiro_id]
    @unidades = Unidade.find(:all, :conditions => ['obreiro_id=?', $obreiro])
    render  :partial => 'empresas'
 end



def lista_relatorio_empresa
    $unidade = params[:relatorio_unidade_id]
   @relatorios = Relatorio.find(:all, :conditions => ['unidade_id=' + $unidade])
    render :partial => 'relatorios'
end

def lista_relatorio_obreiro
    $obreiro = params[:relatorio_obreiro_id]
    @relatorios = Relatorio.find(:all, :conditions => ['obreiro_id=?', $obreiro],:order => 'created_at DESC')
    render :partial => 'relatorios'
end


def lista_relatorio_data
     session[:data] = params[:relatorio_data]
     session[:type]= 3
    if (current_user.unidade_id==9999)
        @relatorios = Relatorio.find(:all, :conditions => ['data=?', session[:data]])
    else if (current_user.obreiro_id == nil)
            @relatorios = Relatorio.find(:all,:include => [:unidade],:conditions => ["unidades.id = ? AND data=?", current_user.unidade_id ,  session[:data]])
            else if (current_user.unidade_id ==  nil)
                   @relatorios = Relatorio.find(:all,:include => [:unidade],:conditions => ["unidades.obreiro_id = ? AND data=?", current_user.obreiro_id ,  session[:data]])
                end
            end
     end
    render :partial => 'relatorios'
end

def impressao
  t= session[:type]
    if session[:type] == '6'
     if (current_user.unidade_id==9999)
         @relatorios = Relatorio.paginate(:all, :page => params[:page], :per_page => 50,:order => 'created_at DESC')
        else
          @relatorios = Relatorio.find(:all,:include => [:unidade],:conditions => ["unidades.id = ?", current_user.unidade_id], :order => 'relatorios.created_at DESC')
        end
     
      render :layout => "impressao"
     
   else if session[:type] == '1'
          if (session[:mese] == 'JANEIRO')
             ano = session[:anoe]
             inicio = "#{Time.now.strftime("%Y")}-01-01 00:00:00"
             fim = "#{Time.now.strftime("%Y")}-01-31 23:59:59"
              @relatorios = Relatorio.find(:all, :include => [:unidade], :conditions => ["relatorios.unidade_id=?  and unidades.id = ? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:unidade_id], current_user.unidade_id], :order => 'created_at DESC')
             render :layout => "impressao"

          else if(session[:mese] == 'FEVEREIRO')
                  ano = session[:anoe]
                  inicio = "#{ano}-02-01 00:00:00"
                  fim = "#{ano}-02-28 23:59:59"
                  @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:unidade_id]],:order => 'created_at DESC')
                  render :layout => "impressao"
          else if(session[:mese]== 'MARÇO')
                      ano =session[:anoe]
                      inicio = "#{Time.now.strftime("%Y")}-03-01 00:00:00"
                      fim = "#{Time.now.strftime("%Y")}-03-31 23:59:59"
                       @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:unidade_id]],:order => 'created_at DESC')
                      render :layout => "impressao"
                   else if(session[:mese]== 'ABRIL')
                          ano =session[:anoe]
                          inicio = "#{Time.now.strftime("%Y")}-04-01 00:00:00"
                          fim = "#{Time.now.strftime("%Y")}-04-30 23:59:59"
                           @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:unidade_id]],:order => 'created_at DESC')
                            render :layout => "impressao"
                         else if(session[:mese]== 'MAIO')
                               ano =session[:anoe]
                               inicio = "#{Time.now.strftime("%Y")}-05-01 00:00:00"
                               fim = "#{Time.now.strftime("%Y")}-05-31 23:59:59"
                                @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:unidade_id]],:order => 'created_at DESC')
                                render :layout => "impressao"
                              else if(session[:mese]== 'JUNHO')
                                    ano =session[:anoe]
                                    inicio = "#{Time.now.strftime("%Y")}-06-01 00:00:00"
                                    fim = "#{Time.now.strftime("%Y")}-06-30 23:59:59"
                                     @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:unidade_id]],:order => 'created_at DESC')
                                     render :layout => "impressao"
                                   else if(session[:mese]== 'JULHO')
                                          ano =session[:anoe]
                                          inicio = "#{Time.now.strftime("%Y")}-07-01 00:00:00"
                                          fim = "#{Time.now.strftime("%Y")}-07-31 23:59:59"
                                          @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:unidade_id]],:order => 'created_at DESC')
                                          render :layout => "impressao"
                                         else if(session[:mese]== 'AGOSTO')
                                                ano =session[:anoe]
                                                inicio = "#{Time.now.strftime("%Y")}-08-01 00:00:00"
                                                fim = "#{Time.now.strftime("%Y")}-08-31 23:59:59"
                                                 @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:unidade_id]],:order => 'created_at DESC')
                                                render :layout => "impressao"
                                              else if(session[:mese]== 'SETEMBRO')
                                                     ano =session[:anoe]
                                                     inicio = "#{Time.now.strftime("%Y")}-09-01 00:00:00"
                                                     fim = "#{Time.now.strftime("%Y")}-09-30 23:59:59"
                                                     @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:unidade_id]],:order => 'created_at DESC')
                                                     render :layout => "impressao"
                                                    else if(session[:mese]== 'OUTUBRO')
                                                           ano =session[:anoe]
                                                           inicio = "#{Time.now.strftime("%Y")}-10-01 00:00:00"
                                                           fim = "#{Time.now.strftime("%Y")}-10-31 23:59:59"
                                                           @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:unidade_id]],:order => 'created_at DESC')
                                                           render :layout => "impressao"
                                                         else if(session[:mese]== 'NOVEMBRO')
                                                                ano =session[:anoe]
                                                                 inicio = "#{Time.now.strftime("%Y")}-11-01 00:00:00"
                                                                 fim = "#{Time.now.strftime("%Y")}-11-30 23:59:59"
                                                                 @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:unidade_id]],:order => 'created_at DESC')
                                                                 render :layout => "impressao"
                                                                 else if(session[:mese]== 'DEZEMBRO')
                                                                     ano =session[:anoe]
                                                                     inicio = "#{Time.now.strftime("%Y")}-012-01 00:00:00"
                                                                     fim = "#{Time.now.strftime("%Y")}-12-31 23:59:59"
                                                                     @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:unidade_id]],:order => 'created_at DESC')
                                                                    render :layout => "impressao"
                                                                  end
                                                              end
                                                         end
                                                   end
                                              end
                                        end
                                   end
                              end
                         end
                    end
               end
          end
      else if session[:type] == '2'
           if (session[:meso]== 'JANEIRO')
             ano =session[:anoo]
             inicio = "#{Time.now.strftime("%Y")}-01-01 00:00:00"
             fim = "#{Time.now.strftime("%Y")}-01-31 23:59:59"
             @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", session[:obreiro]],:order => 'created_at DESC')
             render :layout => "impressao"
          else if(session[:meso]== 'FEVEREIRO')
                  ano =session[:anoo]
                  inicio = "#{ano}-02-01 00:00:00"
                  fim = "#{ano}-02-28 23:59:59"
                   @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", session[:obreiro]],:order => 'created_at DESC')
                   render :layout => "impressao"
               else if(session[:meso]== 'MARÇO')
                      ano =session[:anoo]
                      inicio = "#{Time.now.strftime("%Y")}-03-01 00:00:00"
                      fim = "#{Time.now.strftime("%Y")}-03-31 23:59:59"
                      @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", session[:obreiro]],:order => 'created_at DESC')
                      render :layout => "impressao"
                   else if(session[:meso]== 'ABRIL')
                          ano =session[:anoo]
                          inicio = "#{Time.now.strftime("%Y")}-04-01 00:00:00"
                          fim = "#{Time.now.strftime("%Y")}-04-30 23:59:59"
                           @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", session[:obreiro]],:order => 'created_at DESC')
                           render :layout => "impressao"
                         else if(session[:meso]== 'MAIO')
                               ano =session[:anoo]
                               inicio = "#{Time.now.strftime("%Y")}-05-01 00:00:00"
                               fim = "#{Time.now.strftime("%Y")}-05-31 23:59:59"
                               @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", session[:obreiro]],:order => 'created_at DESC')
                               render :layout => "impressao"
                              else if(session[:meso]== 'JUNHO')
                                    ano =session[:anoo]
                                    inicio = "#{Time.now.strftime("%Y")}-06-01 00:00:00"
                                    fim = "#{Time.now.strftime("%Y")}-06-30 23:59:59"
                                     @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", session[:obreiro]],:order => 'created_at DESC')
                                     render :layout => "impressao"
                                   else if(session[:meso]== 'JULHO')
                                          ano =session[:anoo]
                                          inicio = "#{Time.now.strftime("%Y")}-07-01 00:00:00"
                                          fim = "#{Time.now.strftime("%Y")}-07-31 23:59:59"
                                           @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')",session[:obreiro]],:order => 'created_at DESC')
                                           render :layout => "impressao"
                                         else if(session[:meso]== 'AGOSTO')
                                                ano =session[:anoo]
                                                inicio = "#{Time.now.strftime("%Y")}-08-01 00:00:00"
                                                fim = "#{Time.now.strftime("%Y")}-08-31 23:59:59"
                                                @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", session[:obreiro]],:order => 'created_at DESC')
                                                render :layout => "impressao"
                                              else if(session[:meso]== 'SETEMBRO')
                                                     ano =session[:anoo]
                                                     inicio = "#{Time.now.strftime("%Y")}-09-01 00:00:00"
                                                     fim = "#{Time.now.strftime("%Y")}-09-30 23:59:59"
                                                     @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", session[:obreiro]],:order => 'created_at DESC')
                                                     render :layout => "impressao"
                                                    else if(session[:meso]== 'OUTUBRO')
                                                           ano =session[:anoo]
                                                           inicio = "#{Time.now.strftime("%Y")}-10-01 00:00:00"
                                                           fim = "#{Time.now.strftime("%Y")}-10-31 23:59:59"
                                                           @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", session[:obreiro]],:order => 'created_at DESC')
                                                           render :layout => "impressao"
                                                         else if(session[:meso]== 'NOVEMBRO')
                                                                ano =session[:anoo]
                                                                 inicio = "#{Time.now.strftime("%Y")}-11-01 00:00:00"
                                                                 fim = "#{Time.now.strftime("%Y")}-11-30 23:59:59"
                                                                 @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", session[:obreiro]],:order => 'created_at DESC')
                                                                 render :layout => "impressao"
                                                              else if(session[:meso]== 'DEZEMBRO')
                                                                     ano =session[:anoo]
                                                                     inicio = "#{Time.now.strftime("%Y")}-012-01 00:00:00"
                                                                     fim = "#{Time.now.strftime("%Y")}-12-31 23:59:59"
                                                                     @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", session[:obreiro]],:order => 'created_at DESC')
                                                                     render :layout => "impressao"
                                                                   end
                                                              end
                                                         end
                                                   end
                                              end
                                        end
                                   end
                              end
                         end
                    end
               end
          end
       else if (current_user.unidade_id==9999)
                @relatorios = Relatorio.find(:all, :conditions => ['data=?', session[:data]])
            else if (current_user.obreiro_id == nil)
                    @relatorios = Relatorio.find(:all,:include => [:unidade],:conditions => ["unidades.id = ? AND data=?", current_user.unidade_id ,  session[:data]])
                    else if (current_user.unidade_id ==  nil)
                           @relatorios = Relatorio.find(:all,:include => [:unidade],:conditions => ["unidades.obreiro_id = ? AND data=?", current_user.obreiro_id ,  session[:data]])
                        end
                    end
             end
             render :layout => "impressao"
           end

    end
  end
end



end
