class FinanceirosController < ApplicationController
  # GET /financeiros
  # GET /financeiros.xml
  before_filter :load_unidades
  before_filter :load_financeiro_ano
  before_filter :load_obreiros

 def load_obreiros
      @obreiros = Obreiro.find(:all, :order => 'nome ASC')
  end

def load_unidades
    @unidades = Unidade.find(:all, :order => 'nome ASC')
  end

 def load_financeiro_ano
      @rel_ano = Financeiro.find(:all,:select => 'distinct year(data) as ano',:order => 'data DESC')

  end
  def index
    @financeiros = Financeiro.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @financeiros }
    end
  end

  # GET /financeiros/1
  # GET /financeiros/1.xml
  def show
    @financeiro = Financeiro.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @financeiro }
    end
  end

  # GET /financeiros/new
  # GET /financeiros/new.xml
  def new
    @financeiro = Financeiro.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @financeiro }
    end
  end

  # GET /financeiros/1/edit
  def edit
    @financeiro = Financeiro.find(params[:id])
  end

  # POST /financeiros
  # POST /financeiros.xml
  def create
    @financeiro = Financeiro.new(params[:financeiro])

    respond_to do |format|
      if @financeiro.save
        flash[:notice] = 'Financeiro was successfully created.'
        format.html { redirect_to(@financeiro) }
        format.xml  { render :xml => @financeiro, :status => :created, :location => @financeiro }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @financeiro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /financeiros/1
  # PUT /financeiros/1.xml
  def update
    @financeiro = Financeiro.find(params[:id])

    respond_to do |format|
      if @financeiro.update_attributes(params[:financeiro])
        flash[:notice] = 'Financeiro was successfully updated.'
        format.html { redirect_to(@financeiro) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @financeiro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /financeiros/1
  # DELETE /financeiros/1.xml
  def destroy
    @financeiro = Financeiro.find(params[:id])
    @financeiro.destroy

    respond_to do |format|
      format.html { redirect_to(financeiros_url) }
      format.xml  { head :ok }
    end
  end


 def nome_obreiro
    $obreiro = Unidade.find(params[:financeiro_unidade_id])
    @obreiro = Obreiro.find(:all, :conditions => ['id=?',  $obreiro])
       render  :partial => 'nome_obreiro'
 end

 def consultafinanceiro
   unless params[:search].present?
     if params[:type_of].to_i == 6
       @contador = Relatorio.all.count
        @financeiros = Financeiro.paginate(:all, :page => params[:page], :per_page => 50,:order => 'created_at DESC')
        render :update do |page|
           page.replace_html 'relatorio', :partial => "relatorios"
       end
     end
   else if params[:type_of].to_i == 1
          if (params[:mes_e]== 'JANEIRO')
             ano =params[:ano_e]
             inicio = "#{Time.now.strftime("%Y")}-01-01 00:00:00"
             fim = "#{Time.now.strftime("%Y")}-01-31 23:59:59"
             @financeiros = Financeiro.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:financeiro][:unidade_id]],:order => 'created_at DESC')
             render :update do |page|
                page.replace_html 'financeiro', :partial => "financeiros"
              end
          else if(params[:mes_e]== 'FEVEREIRO')
                  ano =params[:ano_e]
                  inicio = "#{ano}-02-01 00:00:00"
                  fim = "#{ano}-02-28 23:59:59"
                   @financeiros = Financeiro.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:financeiro][:unidade_id]],:order => 'created_at DESC')
                   render :update do |page|
                      page.replace_html 'financeiro', :partial => "financeiros"
                   end
               else if(params[:mes_e]== 'MARÇO')
                      ano =params[:ano_e]
                      inicio = "#{Time.now.strftime("%Y")}-03-01 00:00:00"
                      fim = "#{Time.now.strftime("%Y")}-03-31 23:59:59"
                       @financeiros = Financeiro.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:financeiro][:unidade_id]],:order => 'created_at DESC')
                       render :update do |page|
                          page.replace_html 'financeiro', :partial => "financeiros"
                       end
                   else if(params[:mes_e]== 'ABRIL')
                          ano =params[:ano_e]
                          inicio = "#{Time.now.strftime("%Y")}-04-01 00:00:00"
                          fim = "#{Time.now.strftime("%Y")}-04-30 23:59:59"
                           @financeiros = Financeiro.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:financeiro][:unidade_id]],:order => 'created_at DESC')
                           render :update do |page|
                              page.replace_html 'financeiro', :partial => "financeiros"
                           end
                         else if(params[:mes_e]== 'MAIO')
                               ano =params[:ano_e]
                               inicio = "#{Time.now.strftime("%Y")}-05-01 00:00:00"
                               fim = "#{Time.now.strftime("%Y")}-05-31 23:59:59"
                                @financeiros = Financeiro.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:financeiro][:unidade_id]],:order => 'created_at DESC')
                               render :update do |page|
                                  page.replace_html 'financeiro', :partial => "financeiros"
                               end
                              else if(params[:mes_e]== 'JUNHO')
                                    ano =params[:ano_e]
                                    inicio = "#{Time.now.strftime("%Y")}-06-01 00:00:00"
                                    fim = "#{Time.now.strftime("%Y")}-06-30 23:59:59"
                                     @financeiros = Financeiro.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:financeiro][:unidade_id]],:order => 'created_at DESC')
                                     render :update do |page|
                                        page.replace_html 'financeiro', :partial => "financeiros"
                                     end
                                   else if(params[:mes_e]== 'JULHO')
                                          ano =params[:ano_e]
                                          inicio = "#{Time.now.strftime("%Y")}-07-01 00:00:00"
                                          fim = "#{Time.now.strftime("%Y")}-07-31 23:59:59"
                                         @financeiros = Financeiro.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:financeiro][:unidade_id]],:order => 'created_at DESC')
                                           render :update do |page|
                                              page.replace_html 'financeiro', :partial => "financeiros"
                                           end
                                         else if(params[:mes_e]== 'AGOSTO')
                                                ano =params[:ano_e]
                                                inicio = "#{Time.now.strftime("%Y")}-08-01 00:00:00"
                                                fim = "#{Time.now.strftime("%Y")}-08-31 23:59:59"
                                                 @financeiros = Financeiro.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:financeiro][:unidade_id]],:order => 'created_at DESC')
                                                 render :update do |page|
                                                    page.replace_html 'financeiro', :partial => "financeiros"
                                                 end
                                              else if(params[:mes_e]== 'SETEMBRO')
                                                     ano =params[:ano_e]
                                                     inicio = "#{Time.now.strftime("%Y")}-09-01 00:00:00"
                                                     fim = "#{Time.now.strftime("%Y")}-09-30 23:59:59"
                                                     @financeiros = Financeiro.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:financeiro][:unidade_id]],:order => 'created_at DESC')
                                                     render :update do |page|
                                                        page.replace_html 'financeiro', :partial => "financeiros"
                                                     end
                                                    else if(params[:mes_e]== 'OUTUBRO')
                                                           ano =params[:ano_e]
                                                           inicio = "#{Time.now.strftime("%Y")}-10-01 00:00:00"
                                                           fim = "#{Time.now.strftime("%Y")}-10-31 23:59:59"
                                                           @financeiros = Financeiro.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:financeiro][:unidade_id]],:order => 'created_at DESC')
                                                           render :update do |page|
                                                              page.replace_html 'financeiro', :partial => "financeiros"
                                                           end
                                                         else if(params[:mes_e]== 'NOVEMBRO')
                                                                ano =params[:ano_e]
                                                                 inicio = "#{Time.now.strftime("%Y")}-11-01 00:00:00"
                                                                 fim = "#{Time.now.strftime("%Y")}-11-30 23:59:59"
                                                                 @financeiros = Financeiro.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:financeiro][:unidade_id]],:order => 'created_at DESC')
                                                                 render :update do |page|
                                                                    page.replace_html 'financeiro', :partial => "financeiros"
                                                                 end                                                              else if(params[:mes_e]== 'DEZEMBRO')
                                                                     ano =params[:ano_e]
                                                                     inicio = "#{Time.now.strftime("%Y")}-012-01 00:00:00"
                                                                     fim = "#{Time.now.strftime("%Y")}-12-31 23:59:59"
                                                                     @financeiros = Financeiro.find(:all, :conditions => ["unidade_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:financeiro][:unidade_id]],:order => 'created_at DESC')
                                                                     render :update do |page|
                                                                        page.replace_html 'financeiro', :partial => "financeiros"
                                                                     end                                                                   end
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
                   @financeiros = Finaneiro.find(:all, :conditions => ["obreiro_id=? AND ( data between '#{inicio}' and '#{fim}')", params[:relatorio][:obreiro_id]],:order => 'created_at DESC')
                   render :update do |page|
                      page.replace_html 'financeiro', :partial => "financeiros"
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






end
