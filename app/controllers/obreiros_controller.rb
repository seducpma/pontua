class ObreirosController < ApplicationController
  # GET /obreiros
  # GET /obreiros.xml

  before_filter :load_obreiros
  before_filter :load_unidades

  def load_unidades
     @unidades = Unidade.find(:all, :order => 'nome ASC')
  end


  def load_obreiros
     @obreiros = Obreiro.find(:all, :order => 'nome ASC')
  end

  def index
    @obreiros = Obreiro.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @obreiros }
    end
  end

  # GET /obreiros/1
  # GET /obreiros/1.xml
  def show
    @obreiro = Obreiro.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @obreiro }
    end
  end

  # GET /obreiros/new
  # GET /obreiros/new.xml
  def new
    @obreiro = Obreiro.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @obreiro }
    end
  end

  # GET /obreiros/1/edit
  def edit
    @obreiro = Obreiro.find(params[:id])
  end

  # POST /obreiros
  # POST /obreiros.xml
  def create
    @obreiro = Obreiro.new(params[:obreiro])

    respond_to do |format|
      if @obreiro.save
        flash[:notice] = 'Obreiro was successfully created.'
        format.html { redirect_to(@obreiro) }
        format.xml  { render :xml => @obreiro, :status => :created, :location => @obreiro }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @obreiro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /obreiros/1
  # PUT /obreiros/1.xml
  def update
    @obreiro = Obreiro.find(params[:id])

    respond_to do |format|
      if @obreiro.update_attributes(params[:obreiro])
        flash[:notice] = 'Obreiro was successfully updated.'
        format.html { redirect_to(@obreiro) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @obreiro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /obreiros/1
  # DELETE /obreiros/1.xml
  def destroy
    @obreiro = Obreiro.find(params[:id])
    @obreiro.destroy

    respond_to do |format|
      format.html { redirect_to(obreiros_url) }
      format.xml  { head :ok }
    end
  end

 def consultaobreiro
   unless params[:search].present?
     if params[:type_of].to_i == 4
       @contador = Obreiro.all.count
       @obreiros = Obreiro.paginate(:all, :page => params[:page], :per_page => 50,:order => 'nome ASC')
        render :update do |page|
         page.replace_html 'obreiros', :partial => "obreiros"
       end
     end
   else
      if params[:type_of].to_i == 1
          @contador = Obreiro.all(:conditions => ["nome like ?", "%" + params[:search].to_s + "%"]).count
          @obreiros = Obreiro.paginate( :all,:page => params[:page], :per_page => 50, :conditions => ["nome like ?", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
          render :update do |page|
            page.replace_html 'obreiros', :partial => "obreiros"
          end
          else if params[:type_of].to_i == 2
            render :update do |page|
              page.replace_html 'obreiros', :partial => "obreiros"
            end
              else if params[:type_of].to_i == 3
               render :update do |page|
                 page.replace_html 'obreiros', :partial => "obreiros"
              end
            end
        end
      end
   end
end

  def consulta_nome
    render 'consulta_nome'
  end

  def lista_obreiro_nome
    $obreiro = params[:obreiro_obreiro_id]
    @obreiros = Obreiro.find(:all, :conditions => ['id=' + $obreiro])
    render :partial => 'obreiros'
  end

  def lista_unidade_nome
    $obreiro = params[:unidade_obreiro_id]

    @obreiros = Obreiro.find(:all, :conditions => ['id=' + $obreiro])
    render :partial => 'obreiros'
  end





   def update_empresa
    @funcionario = Funcionario.find(params[:id])
    if @funcionario.update_attributes(params[:funcionario])
      flash[:notice] = 'Dados Atualizados.'
      render :update do |page|
            page.replace_html 'lista', :partial => "lista_empresas"
        end
    end
   end

end
