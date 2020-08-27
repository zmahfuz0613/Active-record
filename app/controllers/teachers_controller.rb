class TeachersController < ApplicationController

  # GET /teachers
  def index
    @teachers = Teacher.all

    render json: @teachers
  end

  # GET /teachers/1
  def show
    @teacher = Teacher.find(params[:id])

    render json: @teacher
  end

end
