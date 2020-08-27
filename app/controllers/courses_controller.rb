# frozen_string_literal: true

class CoursesController < ApplicationController
  # GET /courses
  def index
    @courses = Course.all

    render json: @courses
  end

  # GET /courses/1
  def show
    @course = Course.find(params[:id])

    render json: @course
  end
end
