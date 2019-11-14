json.extract! course_content, :id, :title, :body, :published_at, :content_type, :created_at, :updated_at
json.url course_content_url(course_content, format: :json)
