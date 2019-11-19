require 'rest-client'

class CanvasAPI

  def initialize(canvas_url, auth_token)
    @canvas_url = canvas_url
    @api_url = "#{@canvas_url}/api/v1"
    @global_headers = {
      'Authorization' => "Bearer #{auth_token}",
    }
  end

  def update_course_page(course_id, wiki_page_id, wiki_page_body)
    body = {
      'wiki_page[body]' => wiki_page_body,
    }

    put("/courses/#{course_id}/pages/#{wiki_page_id}", body)
  end

  private

  def get(path, params, headers={})
    RestClient.get("#{@api_url}#{path}", params, @global_headers.merge(headers))
  end

  def post(path, body, headers={})
    RestClient.post("#{@api_url}#{path}", body, @global_headers.merge(headers))
  end

  def put(path, body, headers={})
    RestClient.put("#{@api_url}#{path}", body, @global_headers.merge(headers))
  end
end
