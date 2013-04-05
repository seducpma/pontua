class UnidadesController < ApplicationController
    
 before_filter :load_unidades
 before_filter :load_obreiros

  def load_obreiros
      @obreiros = Obreiro.find(:all, :order => 'nome ASC')
  end

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

  def index
    @unidades = Unidade.all
  end

  def show
    @unidade = Unidade.find(params[:id])
  end

  def new
    @unidade = Unidade.new
  end

  def create
    @unidade = Unidade.new(params[:unidade])
    if @unidade.save
      flash[:notice] = "CADASTRADO COM SUCESSO."
      redirect_to @unidade
    else
      render :action => 'new'
    end
  end

  def edit
    @unidade = Unidade.find(params[:id])
  end

  def update
    @unidade = Unidade.find(params[:id])
    if @unidade.update_attributes(params[:unidade])
      flash[:notice] = "CADASTRADO COM SUCESSO."
      redirect_to @unidade
    else
      render :action => 'edit'
    end
  end

  def destroy
    @unidade = Unidade.find(params[:id])
    @unidade.destroy
    flash[:notice] = "EXCLUIDO COM SUCESSO."
    redirect_to unidades_url
  end

  def mesmo_nome
    $nome = params[:unidade_nome]
    @verifica = Unidade.find_by_nome($nome)
    if @verifica then
      render :update do |page|
        page.replace_html 'nome_aviso', :text => 'EMPRESA JÁ CADASTRADA'
        page.replace_html 'Certeza', :text =>'EMPRESA JÁ CADASTRADA'
    end
    else
      render :update do |page|
        page.replace_html 'nome_aviso', :text => ''
      end

    end
  end

  def consultaempresa
   unless params[:search].present?
     if params[:type_of].to_i == 3
       @contador = Unidade.all(:conditions => ["id = ?", current_user.unidade_id]).count
             if (current_user.unidade_id==9999)
          @unidades = Unidade.find(:all, :order => 'nome ASC')
       else if (current_user.obreiro_id == nil)
            @unidades = Unidade.find(:all,:conditions => ["id = ?", current_user.unidade_id], :order => 'nome ASC')
            else if (current_user.unidade_id ==  nil)
                  @unidades = Unidade.find(:all,:conditions => ["obreiro_id = ?", current_user.obreiro_id], :order => 'nome ASC')
                  end
             end
       end
          render :update do |page|
         page.replace_html 'empresas', :partial => "empresas"
       end
     end
   else
      if params[:type_of].to_i == 1
          @contador = Unidade.all(:conditions => ["nome like ?", "%" + params[:search].to_s + "%"]).count
          @unidades = Unidade.paginate( :all,:page => params[:page], :per_page => 50, :conditions => ["nome like ?", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
          render :update do |page|
            page.replace_html 'empresas', :partial =>  'lista_empresas_nome'
          end
          else if params[:type_of].to_i == 2
            render :update do |page|
              page.replace_html 'empresaslivros', :partial =>  'lista_empresas_nome'
            end
          end
      end
   end
end

  def consulta_nome
    render 'consulta_nome'
  end

 def lista_empresa_nome
    $unidade = params[:unidade_unidade_id]
    @unidades = Unidade.find(:all, :conditions => ['id=' + $unidade])
    render :partial => 'lista_empresas_nome'
  end
end
