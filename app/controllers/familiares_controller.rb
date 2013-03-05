class FamiliaresController < ApplicationController
  # GET /familiares
  # GET /familiares.xml
    before_filter :load_funcionarios

  def load_funcionarios
      @funcionarios = Funcionario.find(:all, :order => 'nome ASC')
  end

  def index
    @familiares = Familiare.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :action => "new", :controller => :funcionarios }

    end
  end

  # GET /familiares/1
  # GET /familiares/1.xml
  def show
    @familiare = Familiare.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @familiare }
    end
  end

  # GET /familiares/new
  # GET /familiares/new.xml
  def new
    @familiare = Familiare.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @familiare }
    end
  end

  # GET /familiares/1/edit
  def edit
    @familiare = Familiare.find(params[:id])
  end

  # POST /familiares
  # POST /familiares.xml
  def create
    @familiare = Familiare.new(params[:familiare])

    respond_to do |format|
      if @familiare.save
        flash[:notice] = 'Familiare was successfully created.'
        format.html { redirect_to(@familiare) }
        format.xml  { render :xml => @familiare, :status => :created, :location => @familiare }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @familiare.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /familiares/1
  # PUT /familiares/1.xml
  def update
    @familiare = Familiare.find(params[:id])

    respond_to do |format|
      if @familiare.update_attributes(params[:familiare])
        flash[:notice] = 'Familiare was successfully updated.'
        format.html { redirect_to(@familiare) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @familiare.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /familiares/1
  # DELETE /familiares/1.xml
  def destroy
    @familiare = Familiare.find(params[:id])
    @familiare.destroy

    respond_to do |format|
      format.html { redirect_to(familiares_url) }
      format.xml  { head :ok }
    end
  end

   # def destroy
   # @professor = Professor.find(params[:id])
   # $prof_id = params[:id]
   # @titulo_professor = TituloProfessor.find(:all, :conditions => ['professor_id = ' + $prof_id])
   # @acum_professor = AcumTrab.find(:all, :conditions => ['professor_id = ' + $prof_id])
   # @trabalhado_professor = Trabalhado.find(:all, :conditions => ['professor_id = ' + $prof_id])
   # for titu_prof in @titulo_professor
   #   titu_prof.destroy
   # end
    #for trab_prof in @trabalhado_professor
    #  trab_prof.destroy
    #end
    #for acum_prof in @acum_professor
    #  acum_prof.destroy
    #end


  def consultafamiliar
   unless params[:search].present?
     if params[:type_of].to_i == 3
       @contador = Familiare.all.count
       @familiares = Familiare.paginate(:all, :page => params[:page], :per_page => 50,:order => 'nome ASC')
        render :update do |page|
         page.replace_html 'familiares', :partial => "familiares"
       end
     end
   else
      if params[:type_of].to_i == 1
          @contador = Familiare.all(:conditions => ["nome like ?", "%" + params[:search].to_s + "%"]).count
          @familiares = Familiare.paginate( :all,:page => params[:page], :per_page => 50, :conditions => ["nome like ?", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
          render :update do |page|
            page.replace_html 'familiares', :partial => "familiares"
          end
              else if params[:type_of].to_i == 2
               render :update do |page|
                 page.replace_html 'familiares', :partial => "familiares"
              end
            end
      end
   end
end

  def lista_familiares_nome
    $funcionario = params[:funcionario_funcionario_id]
    @familiares = Familiare.find(:all, :conditions => ['funcionario_id=' + $funcionario])
    render :partial => 'familiares'
  end


end
