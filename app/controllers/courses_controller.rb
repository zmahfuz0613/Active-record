class CoursesController < ApplicationController
  def index
    @teacher = Teacher.find(params[:teacher_id])
    @courses = @teacher.courses
  end

  def show
    @course = Course.find(params[:id])
    @students = @course.students.order(:name)
    @teacher = @course.teacher
  end
end
