class CourseContent < ApplicationRecord
  def publish(params)
    response = CanvasProdClient.update_course_page(params[:course_id], params[:secondary_id], params[:body])

    response.code == 200
  end
end
