# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter '/features/'
  add_filter '/spec/'
  merge_timeout 3600
end
