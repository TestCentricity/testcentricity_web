# frozen_string_literal: true

require 'simplecov'

if ENV['COVERAGE']
  SimpleCov.start do
    add_filter '/features/'
    add_filter '/spec/'
    merge_timeout 7200
  end
end
