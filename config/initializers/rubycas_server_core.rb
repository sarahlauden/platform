cas_config = YAML.load_file("#{Rails.root.to_s}/config/rubycas.yml")[Rails.env]
RubyCAS::Server::Core::setup(cas_config)
