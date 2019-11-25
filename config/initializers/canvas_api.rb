require 'canvas_api'

canvas_config = YAML.safe_load(ERB.new(File.read("#{Rails.root.to_s}/config/canvas.yml")).result, [], [], true)[Rails.env].with_indifferent_access
::CanvasProdClient = CanvasAPI.new(canvas_config[:canvas_url], canvas_config[:canvas_token])
