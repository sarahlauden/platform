Honeycomb.configure do |config|
  config.write_key = Rails.application.secrets.honeycomb_api_key
  config.dataset = Rails.application.secrets.honeycomb_dataset
end