require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'rake'


namespace :features do
  Cucumber::Rake::Task.new(:edge_local) do |t|
    t.profile = 'edge_local'
  end

  Cucumber::Rake::Task.new(:chrome_local) do |t|
    t.profile = 'chrome_local'
  end

  Cucumber::Rake::Task.new(:edge_headless) do |t|
    t.profile = 'edge_headless'
  end

  Cucumber::Rake::Task.new(:chrome_headless) do |t|
    t.profile = 'chrome_headless'
  end

  Cucumber::Rake::Task.new(:safari_local) do |t|
    t.profile = 'safari_local'
  end

  Cucumber::Rake::Task.new(:firefox_local) do |t|
    t.profile = 'firefox_local'
  end

  Cucumber::Rake::Task.new(:firefox_headless) do |t|
    t.profile = 'firefox_headless'
  end

  Cucumber::Rake::Task.new(:edge_grid) do |t|
    t.profile = 'edge_grid'
  end

  Cucumber::Rake::Task.new(:chrome_grid) do |t|
    t.profile = 'chrome_grid'
  end

  Cucumber::Rake::Task.new(:firefox_grid) do |t|
    t.profile = 'firefox_grid'
  end

  Cucumber::Rake::Task.new(:ios_remote) do |t|
    t.profile = 'ios_remote'
  end


  task :required => [:edge_local, :edge_headless, :chrome_local, :chrome_headless, :safari_local]

  task :grid => [:edge_grid, :chrome_grid]

  task :mobile => [:ios_remote]

  task :all => [:edge_local, :edge_headless, :chrome_local, :chrome_headless, :safari_local, :edge_grid, :chrome_grid]
end
