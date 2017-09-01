class CoursesController < ApplicationController
  def index
    @teacher = Teacher.find(params[:teacher_id])
    @courses = @teacher.courses
  end

  def show
    @course = Course.find(params[:id])
    @students = @course.students.order(:name)
    @teacher = @course.teacher

    @pairs = @course.generate_pairs
    @top_student = @course.top_student
  end
end
