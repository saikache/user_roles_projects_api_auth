class Api::ProjectsController < ApplicationController
  before_action :authorize
  before_action :set_project, only: [:show, :update, :destroy, :add_user_to_project]
  before_action :can_manage_project_users, only: [:add_user_to_project]

  private
  def can_manage_project_users
    error_response('You don\'t have access to assign users', 401) unless current_user.can_edit('Project')
  end

  public
  # GET /api/projects
  def index
    projects = Project.all
    render_success(ActiveModelSerializers::SerializableResource.new projects)
  end

  # GET /api/projects/1
  def show
    render_success(ProjectWithUsersSerializer.new @project)
  end

  def add_user_to_project
    permited_params =  params.permit(:user_id)
    unless @project.users.ids.include?(permited_params[:user_id])
      user = User.find_by(id: permited_params[:user_id])
      if user
        @project.users.push(user)
        render_success('User added to the project successfully')
      else
        error_response('User not found')
      end
    else
      error_response('User already added')
    end
  end

  # POST /api/projects
  def create
    if current_user.can_new('Project')
      @project = Project.new(project_params)
      if @project.save
        render_success(ProjectSerializer.new @project)
      else
        error_response(@project.errors.full_messages)
      end
    else
      error_response('You don\'t have access to create project', 401)          
    end
  end

  # PATCH/PUT /api/projects/1
  def update
    if @project.update(project_params)
      render_success(ProjectSerializer.new @project)
    else
      error_response(@project.errors.full_messages)
    end
  end

  # DELETE /api/projects/1
  def destroy
    if current_user.can_delete('Project')
      if @project.destroy
        render_success('Project deleted successfully')
      else
        error_response(@project.errors.full_messages.join(', '))
      end
    else
      error_response('You don\'t have access to delete project', 401)          
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find_by(id: params[:id])
      return error_response('No project found') unless @project
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name)
    end
end
