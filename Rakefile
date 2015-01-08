require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:unit)

require 'rubocop/rake_task'
desc 'Run Ruby style checks'
RuboCop::RakeTask.new(:style)

require 'foodcritic'
FoodCritic::Rake::LintTask.new do |t|
  t.options = {
    fail_tags: ['any'],
    tags: ['~FC037']
  }
end
