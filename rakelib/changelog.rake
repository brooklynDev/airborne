require 'github_changelog_generator/task'

if ENV['CHANGELOG_GITHUB_TOKEN'].nil?
  warn '[rake changelog] You need to export CHANGELOG_GITHUB_TOKEN first! You can generate one at: https://github.com/settings/tokens/new'
  return
end

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.project = 'airborne'

  # change this to your github username if you plan to submit a PR with a new CHANGELOG.md
  config.user = 'brooklynDev'
end

