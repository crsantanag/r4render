class CoursesController < ApplicationController
  before_action :authenticate_user!

  before_action only: [ :new, :create, :inscritos, :edit, :update, :destroy ] do
    authorize_request([ "admin" ])
  end

  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  def inscritos
    @courses = Course.order(created_at: :desc)
  end

  # GET /courses/1 or /courses/1.json
  def show
    @course = Course.find(params[:id])
    @enrollment = Enrollment.new
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    @course.user_id = current_user.id

    respond_to do |format|
      if @course.save
        flash[:alert] = "CURSO CREADO"
        format.html { redirect_to @course, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        flash[:alert] = "CURSO ACTUALIZADO"
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!

    flash[:alert] = "CURSO ELIMINADO"
    respond_to do |format|
      format.html { redirect_to courses_path, status: :see_other, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    def authorize_admin
      unless current_user&.admin?
        flash[:alert] = "NO ESTÁ AUTORIZADO PARA ACCEDER A ESTA PÁGINA"
        redirect_to root_path
      end
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:title, :description, :duration, :user_id)
    end
end
