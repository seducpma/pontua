class ProfessorsController < ApplicationController

before_filter :load_unidades
before_filter :load_professors

  def load_unidades
    @unidades = Unidade.find(:all, :order => "nome")
  end


  def load_professors
      @professors = Professor.find(:all, :order => 'nome ASC')
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
        flash[:notice] = 'Professor was successfully created.'
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
        flash[:notice] = 'Professor was successfully updated.'
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
   unless params[:search].present?
     if params[:type_of].to_i == 3
        @professors = Professor.find(:all,:order => 'nome ASC')
        render :update do |page|
         page.replace_html 'professores', :partial => "professores"
       end
     end
     if params[:type_of].to_i == 2
        @professors = Professor.find(:all, :conditions=> ["desligado = 0"],:order => 'nome ASC')
        render :update do |page|
        page.replace_html 'professores', :partial => "professores"
       end
     end
     if params[:type_of].to_i == 4
        @professors = Professor.find(:all, :conditions=> ["desligado = 1"],:order => 'nome ASC')
        render :update do |page|
        page.replace_html 'professores', :partial => "professores"
        end
     end
  else if params[:type_of].to_i == 1
         @professors = Professor.paginate( :all,:page => params[:page], :per_page => 50, :conditions => ["nome like ?", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
          render :update do |page|
            page.replace_html 'professores', :partial => "professores"
          end
       end
       if params[:type_of].to_i == 5
              render :update do |page|
                page.replace_html 'professores', :partial => "professores"
              end
       end
       if params[:type_of].to_i == 6
         @professors = Professor.find( :all,:conditions => ["funcao like ?", "%" + params[:search].to_s + "%"],:order => 'nome ASC')
              render :update do |page|
                page.replace_html 'professores', :partial => "professores"
              end
       end



   end
end

  def lista_professor_unidade
    $sede = params[:unidade_id]
    @professors = Professor.find(:all, :conditions => ['sede_id=' + $sede])
    render :partial => 'professores'
  end
end
