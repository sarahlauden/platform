json.extract! content, :id, :title, :body, :published_at, :type, :created_at, :updated_at
json.url content_url(content, format: :json)
