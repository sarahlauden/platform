require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_hosts 'platformweb', 'stagingplatform.bebraven.org', 'platform.bebraven.org'
end
