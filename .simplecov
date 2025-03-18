# frozen_string_literal: true

require 'simplecov'

if ENV['COVERAGE']
  SimpleCov.start do
    add_filter '/features/'
    add_filter '/spec/'
    merge_timeout 9600
  end
end
