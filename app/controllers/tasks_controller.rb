class TasksController < ApplicationController
  before_action :find_task, only: [:show, :edit, :update, :destroy]
  before_action :tags_collection, only: [:new, :edit]
  skip_before_action :set_ransack_obj, only: [:index]

  def index
    @q = @current_user.tasks.includes(:user).ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page])

  end

  def show
  end

  def new
    @task = Task.new

  end

  def create
    @task = @current_user.tasks.build(task_params)
    if @task.save
      flash[:notice] = I18n.t("task.create_success")
      redirect_to tasks_path
    else
      render :new
      flash[:notice] = I18n.t("task.create_failed")
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:notice] = I18n.t("task.edit_success")
      redirect_to tasks_path
    else
      render :edit 
      flash[:notice] = I18n.t("task.edit_failed")
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = I18n.t("task.delete_success")
    else
      flash[:notice] = I18n.t("task.delete_failed")
    end
    redirect_to tasks_path
  end

  private
  
  def task_params
    params.require(:task).permit(:name,
                                 :description, 
                                 :priority, 
                                 :status, 
                                 :start_at, 
                                 :end_at,
                                 { tag_items: [] }
                                 )
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def tags_collection
    @tags = []
    @current_user.tasks.each do |task|
      task.tags.each do |tag|
        @tags << tag.name
      end
    end
    @tags.uniq!
  end
end