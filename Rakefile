require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'rake'


namespace :features do
  Cucumber::Rake::Task.new(:edge) do |t|
    t.profile = 'edge'
  end

  Cucumber::Rake::Task.new(:chrome) do |t|
    t.profile = 'chrome'
  end

  Cucumber::Rake::Task.new(:edge_headless) do |t|
    t.profile = 'edge_headless'
  end

  Cucumber::Rake::Task.new(:chrome_headless) do |t|
    t.profile = 'chrome_headless'
  end

  Cucumber::Rake::Task.new(:safari) do |t|
    t.profile = 'safari'
  end

  Cucumber::Rake::Task.new(:firefox) do |t|
    t.profile = 'firefox'
  end

  Cucumber::Rake::Task.new(:firefox_headless) do |t|
    t.profile = 'firefox_headless'
  end

  task :all => [:edge, :edge_headless, :chrome, :chrome_headless, :safari]
end
