class EnrollmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: [ :create ]
  before_action :set_enrollment, only: %i[ show edit destroy ]

  # GET /enrollments or /enrollments.json
  def index
    @enrollments = Enrollment.where(user_id: current_user.id).order(created_at: :asc)
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit
  end

  # POST /enrollments or /enrollments.json
  def create
    # @enrollment = Enrollment.new(enrollment_params)
    @enrollment = @course.enrollments.build(enrollment_params)

    if !user_signed_in?
      flash[:alert] = "DEBE INICIAR SESIÓN PARA INSCRIBIR CURSO"
      redirect_to root_path
      return
    elsif Enrollment.exists?(user_id: current_user.id, course_id: @course.id)
      flash[:alert] = "NO PUEDE INSCRIBIR EL MISMO CURSO MAS DE 1 VEZ"
      redirect_to courses_path
      return
    end

    @enrollment.user_id = current_user.id
    @enrollment.course_id = @course.id

    respond_to do |format|
      if @enrollment.save
        flash[:alert] = "INSCRIPCION REALIZADA"
        format.html { redirect_to enrollments_path, notice: "Enrollment was successfully created." }
        format.json { render :show, status: :created, location: @enrollment }
      else
        format.html { render "courses/show", status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    @enrollment.destroy!

    respond_to do |format|
      flash[:alert] = "INSCRIPCION ELIMINADA"
      format.html { redirect_to enrollments_path, status: :see_other, notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])

      if !@enrollment
        flash[:alert] = "LA INSCRIPCIÓN NO SE ENCONTRÓ O FUE ELIMINADA"
        redirect_to courses_path
      end
    end

    def set_course
      @course = Course.find(params[:course_id]) # El curso debe existir para inscribirse

      if !@course
        flash[:alert] = "EL CURSO NO SE ENCONTRÓ O FUE ELIMINADO"
        redirect_to courses_path
      end
    end

    # Only allow a list of trusted parameters through.
    def enrollment_params
      params.require(:enrollment).permit(:progress, :user_id, :course_id)
    end
end
