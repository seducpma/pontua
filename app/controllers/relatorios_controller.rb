class RelatoriosController < ApplicationController
  # GET /relatorios
  # GET /relatorios.xml

   before_filter :load_obreiros
   before_filter :load_unidades
   before_filter :load_relatorios_ano

  def load_unidades
      @unidades = Unidade.find(:all, :order => 'nome ASC')
  end

  def load_obreiros
      @obreiros = Obreiro.find(:all, :order => 'nome ASC')
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
        flash[:notice] = 'Relatorio was successfully created.'
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
        flash[:notice] = 'Relatorio was successfully updated.'
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
   unless params[:search].present?
     if params[:type_of].to_i == 6
       @contador = Relatorio.all.count
       @relatorios = Relatorio.paginate(:all, :page => params[:page], :per_page => 50,:order => 'created_at DESC')
        render :update do |page|
           page.replace_html 'relatorio', :partial => "relatorios"
       end
     end
   else if params[:type_of].to_i == 1
          if (params[:mes_e]== 'JANEIRO')
             ano =params[:ano_e]
             inicio = "#{Time.now.strftime("%Y")}-01-01 00:00:00"
             fim = "#{Time.now.strftime("%Y")}-01-31 23:59:59"
             @relatorios = Relatorio.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:unidade_id]],:order => 'created_at DESC')
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
          $mes = params[:mes]
          if (params[:mes]== 'JANEIRO')
             ano =params[:ano]
             inicio = "#{Time.now.strftime("%Y")}-01-01 00:00:00"
             fim = "#{Time.now.strftime("%Y")}-01-31 23:59:59"
             @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
             render :update do |page|
               page.replace_html 'relatorio', :partial => "relatorios"
             end
          else if(params[:mes]== 'FEVEREIRO')
                  ano =params[:ano]
                  inicio = "#{ano}-02-01 00:00:00"
                  fim = "#{ano}-02-28 23:59:59"
                   @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                   render :update do |page|
                      page.replace_html 'relatorio', :partial => "relatorios"
                   end
               else if(params[:mes]== 'MARÇO')
                      ano =params[:ano]
                      inicio = "#{Time.now.strftime("%Y")}-03-01 00:00:00"
                      fim = "#{Time.now.strftime("%Y")}-03-31 23:59:59"
                      @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                      render :update do |page|
                        page.replace_html 'relatorio', :partial => "relatorios"
                       end
                   else if(params[:mes]== 'ABRIL')
                          ano =params[:ano]
                          inicio = "#{Time.now.strftime("%Y")}-04-01 00:00:00"
                          fim = "#{Time.now.strftime("%Y")}-04-30 23:59:59"
                           @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                           render :update do |page|
                             page.replace_html 'relatorio', :partial => "relatorios"
                           end
                         else if(params[:mes]== 'MAIO')
                               ano =params[:ano]
                               inicio = "#{Time.now.strftime("%Y")}-05-01 00:00:00"
                               fim = "#{Time.now.strftime("%Y")}-05-31 23:59:59"
                               @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                               render :update do |page|
                                  page.replace_html 'relatorio', :partial => "relatorios"
                               end
                              else if(params[:mes]== 'JUNHO')
                                    ano =params[:ano]
                                    inicio = "#{Time.now.strftime("%Y")}-06-01 00:00:00"
                                    fim = "#{Time.now.strftime("%Y")}-06-30 23:59:59"
                                     @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                     render :update do |page|
                                        page.replace_html 'relatorio', :partial => "relatorios"
                                     end
                                   else if(params[:mes]== 'JULHO')
                                          ano =params[:ano]
                                          inicio = "#{Time.now.strftime("%Y")}-07-01 00:00:00"
                                          fim = "#{Time.now.strftime("%Y")}-07-31 23:59:59"
                                           @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')",params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                           render :update do |page|
                                              page.replace_html 'relatorio', :partial => "relatorios"
                                           end
                                         else if(params[:mes]== 'AGOSTO')
                                                ano =params[:ano]
                                                inicio = "#{Time.now.strftime("%Y")}-08-01 00:00:00"
                                                fim = "#{Time.now.strftime("%Y")}-08-31 23:59:59"
                                                @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                                render :update do |page|
                                                     page.replace_html 'relatorio', :partial => "relatorios"
                                                end
                                              else if(params[:mes]== 'SETEMBRO')
                                                     ano =params[:ano]
                                                     inicio = "#{Time.now.strftime("%Y")}-09-01 00:00:00"
                                                     fim = "#{Time.now.strftime("%Y")}-09-30 23:59:59"
                                                     @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                                     render :update do |page|
                                                       page.replace_html 'relatorio', :partial => "relatorios"
                                                     end
                                                    else if(params[:mes]== 'OUTUBRO')
                                                           ano =params[:ano]
                                                           inicio = "#{Time.now.strftime("%Y")}-10-01 00:00:00"
                                                           fim = "#{Time.now.strftime("%Y")}-10-31 23:59:59"
                                                           @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                                           render :update do |page|
                                                             page.replace_html 'relatorio', :partial => "relatorios"
                                                           end
                                                         else if(params[:mes]== 'NOVEMBRO')
                                                                ano =params[:ano]
                                                                 inicio = "#{Time.now.strftime("%Y")}-11-01 00:00:00"
                                                                 fim = "#{Time.now.strftime("%Y")}-11-30 23:59:59"
                                                                 @relatorios = Relatorio.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                                                                 render :update do |page|
                                                                      page.replace_html 'relatorio', :partial => "relatorios"
                                                                 end
                                                              else if(params[:mes]== 'DEZEMBRO')
                                                                     ano =params[:ano]
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
    $data = params[:relatorio_data]
    @relatorios = Relatorio.find(:all, :conditions => ['data=?', $data])
    render :partial => 'relatorios'
end

end
