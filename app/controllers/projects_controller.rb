class ProjectsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def update_cache
    Project::update_cache(@current_user.basecamp_url + '.basecamphq.com', @current_user.basecamp_api_key)
    flash[:notice] = "Updated Projects from Basecamp."
    redirect_to root_url
  end
  
  def hidden
    
    @milestone_presets = Milestone::presets
    @projects = Project.find_all_by_hidden_and_status(1,'active')
    render "index"
    
  end
  
  def hide

    project = Project.find(params[:id])
    
    project.hidden = 1
    project.save
    flash[:notice] = "Removed " + project.name + " from the list."
    redirect_to root_url

  end
  
  def show

    project = Project.find(params[:id])
    project.hidden = nil
    project.save
    flash[:notice] = "Added " + project.name + " to the list."
    redirect_to root_url

  end
  
  
  # GET /projects
  # GET /projects.xml
  def index
    @milestone_presets = Milestone::presets
    @projects = Project.find_all_by_hidden_and_status(nil,'active')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to(root_url, :notice => @project.name + ' was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(root_url, :notice => @project.name + ' was successfully created.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_index_url) }
      format.xml  { head :ok }
    end
  end
end
