RSpec.configure do |config|
  config.add_setting :base_url
  config.add_setting :match_expected_default, default: true
  config.add_setting :match_actual_default, default: false
  config.add_setting :match_expected, default: config.match_expected_default
  config.add_setting :match_actual, default: config.match_actual_default
  config.add_setting :headers
  config.add_setting :rack_app
  config.add_setting :requester_type
  config.add_setting :requester_module
  config.around(:example, match_expected: !config.match_expected_default) do |example|
    config.match_expected = !config.match_expected_default
    example.run
    config.match_expected = config.match_expected_default
  end
  config.around(:example, match_actual: !config.match_actual_default) do |example|
    config.match_actual = !config.match_actual_default
    example.run
    config.match_actual = config.match_actual_default
  end
end
