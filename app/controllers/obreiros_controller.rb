class ObreirosController < ApplicationController
  # GET /obreiros
  # GET /obreiros.xml

  before_filter :load_obreiros
  before_filter :load_unidades

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
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
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
        flash[:notice] = 'CADASTRADO COM SUCESSO.'
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
      if (current_user.unidade_id==9999)
           @obreiros = Obreiro.paginate(:all, :page => params[:page], :per_page => 50, :order => 'nome ASC')
       else if (current_user.obreiro_id == nil)
             @obreiros = Obreiro.find(:all,:include => [:unidades],:conditions => ["unidades.id = ?", current_user.unidade_id])
            else if (current_user.unidade_id ==  nil)
                   @obreiros = Obreiro.find(:all,:include => [:unidades], :conditions => ["unidades.obreiro_id = ?", current_user.obreiro_id])
                    
                  end
             end




          
      end
        render :update do |page|
         page.replace_html 'obreiros', :partial => "obreiros"
       end
     end
   else
      if params[:type_of].to_i == 1
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

     $unidade = params[:unidade][:id]

    @unidade = Unidade.find(params[:unidade][:id])
    nome=@unidade.nome
    obreiro=@unidade.obreiro_id
    if @funcionario.update_attributes(params[:funcionario])
      flash[:notice] = 'Dados Atualizados.'
      render :update do |page|
            page.replace_html 'lista', :partial => "lista_empresas"
        end
    end
   end

end
