if Gem.loaded_specs.has_key?('honeycomb-beeline')
  Rails.logger.info "Honeycomb detected. Initalizing setup."
  require "honeycomb-beeline"

  Honeycomb.configure do |config|
    config.write_key = Rails.application.secrets.honeycomb_write_key
    config.dataset = Rails.application.secrets.honeycomb_dataset
  end
else
  Rails.logger.warn "Honeycomb is not install. Skipping initialization."
end
