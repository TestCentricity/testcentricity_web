require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'docker/compose'
require 'parallel_tests'
require 'rake'


namespace :features do
  Cucumber::Rake::Task.new(:safari_local) do |t|
    t.profile = 'safari_local'
  end

  Cucumber::Rake::Task.new(:ios_remote) do |t|
    t.profile = 'ios_remote'
  end

  task :required do
    %w[chrome_local chrome_headless firefox_local firefox_headless edge_local edge_headless ipad_pro_12_local].each do |profile|
      system "parallel_cucumber features/ -o '-p #{profile}' -n 6 --group-by scenarios"
    end
  end

  task :grid do
    # start up Selenium Grid
    compose = Docker::Compose.new
    compose.version
    compose.up(detached: true)
    # run grid features
    %w[chrome_grid firefox_grid edge_grid ipad_pro_12_grid].each do |profile|
      system "parallel_cucumber features/ -o '-p #{profile}' -n 4"
    end
    # shut down Selenium Grid
    compose.down(remove_volumes: true)
  end

  task :mobile => [:ios_remote]

  task :all => [
    :required,
    :grid,
    :safari_local,
    :mobile
  ]
end
