require 'github_changelog_generator/task'

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  raise(
    ArgumentError,
    'You need to export CHANGELOG_GITHUB_TOKEN first! You can generate one at: https://github.com/settings/tokens/new'
  ) if ENV['CHANGELOG_GITHUB_TOKEN'].nil?

  config.project = 'airborne'

  # change this to your github username if you plan to submit a PR with a new CHANGELOG.md
  config.user = 'brooklynDev'
end

