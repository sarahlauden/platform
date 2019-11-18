require 'rest-client'

class CanvasAPI

  DEFAULT_CANVAS_URL = 'https://portal.bebraven.org/api/v1'

  def initialize(canvas_url, auth_token)
    @canvas_url = canvas_url || DEFAULT_CANVAS_URL
    @global_headers = {
      'Authorization' => "Bearer #{auth_token}",
    }
  end

  public

  def update_course_page(course_id, wiki_page_id, wiki_page_body)
    body = {
      'wiki_page[body]' => wiki_page_body,
    }

    put("/courses/#{course_id}/pages/#{wiki_page_id}", body)
  end

  private

  def get(path, params, headers={})
    RestClient.get("#{@canvas_url}#{path}", params, @global_headers.merge(headers))
  end

  def post(path, body, headers={})
    RestClient.post("#{@canvas_url}#{path}", body, @global_headers.merge(headers))
  end

  def put(path, body, headers={})
    puts @global_headers
    RestClient.put("#{@canvas_url}#{path}", body, @global_headers.merge(headers))
  end
end
