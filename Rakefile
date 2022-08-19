require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'docker/compose'
require 'parallel_tests'
require 'rake'
require 'rspec/core/rake_task'
require 'simplecov'
require 'yard'


desc 'Run required specs'
RSpec::Core::RakeTask.new(:required_specs) do |t|
  t.rspec_opts = '--tag required'
end


desc 'Run grid WebDriver specs'
RSpec::Core::RakeTask.new(:grid_specs) do |t|
  t.rspec_opts = '--tag grid'
end


desc 'Run mobile WebDriver specs'
RSpec::Core::RakeTask.new(:mobile_specs) do |t|
  t.rspec_opts = '--tag mobile'
end


desc 'Run BrowserStack specs'
RSpec::Core::RakeTask.new(:browserstack_specs) do |t|
  t.rspec_opts = '--tag browserstack'
end


desc 'Run TestingBot specs'
RSpec::Core::RakeTask.new(:testingbot_specs) do |t|
  t.rspec_opts = '--tag testingbot'
end


desc 'Run Cucumber features on local Safari browser'
Cucumber::Rake::Task.new(:safari_local) do |t|
  t.profile = 'safari_local'
end


desc 'Run Cucumber features on iOS simulator'
Cucumber::Rake::Task.new(:ios_remote) do |t|
  t.profile = 'ios_remote'
end


desc 'Run required Cucumber features on local web browsers'
task :required_cukes do
  %w[chrome_local chrome_headless firefox_local firefox_headless edge_local edge_headless ipad_pro_12_local].each do |profile|
    system "parallel_cucumber features/ -o '-p #{profile} -p parallel' -n 6 --group-by scenarios"
  end
end


desc 'Run grid Cucumber features on Dockerized Selenium 4 Grid'
task :grid_cukes do
  # start up Selenium 4 Grid
  compose = Docker::Compose.new
  compose.version
  compose.up(detached: true)
  # run grid features
  begin
    %w[chrome_grid firefox_grid edge_grid ipad_pro_12_grid].each do |profile|
      system "parallel_cucumber features/ -o '-p #{profile} -p parallel' -n 4 --group-by scenarios"
    end
  ensure
    # shut down Selenium Grid
    compose.down(remove_volumes: true)
  end
end


desc 'Run grid specs on Dockerized Selenium 4 Grid'
task :docker_grid_specs do
  # start up Selenium 4 Grid
  compose = Docker::Compose.new
  compose.version
  compose.up(detached: true)
  # run grid specs
  begin
    Rake::Task[:grid_specs].invoke
  ensure
    # shut down Selenium Grid
    compose.down(remove_volumes: true)
  end
end


desc 'Run mobile web specs and Cucumber features'
task mobile: [:mobile_specs, :ios_remote]


desc 'Run required specs and Cucumber features'
task required: [:required_specs, :required_cukes]


desc 'Run grid specs and Cucumber features on Dockerized Selenium 4 Grid'
task grid: [:docker_grid_specs, :grid_cukes]


desc 'Run all specs'
task all_specs: [:required_specs, :docker_grid_specs, :mobile_specs, :browserstack_specs, :testingbot_specs]


desc 'Run all specs and Cucumber features'
task all: [:required, :browserstack_specs, :testingbot_specs, :safari_local, :grid, :mobile]


desc 'Update HTML docs'
YARD::Rake::YardocTask.new(:docs) do |t|
  t.files = ['lib/**/*.rb']
end


desc 'Build and release new version'
task :release do
  version = TestCentricityWeb::VERSION
  puts "Releasing version #{version} of TestCentricityWeb gem, y/n?"
  exit(1) unless $stdin.gets.chomp == 'y'
  sh 'gem build testcentricity_web.gemspec && ' \
     "gem push testcentricity_web-#{version}.gem"
end


desc 'Update docs, build gem, and push to RubyGems'
task ship_it: [:docs, :release]
