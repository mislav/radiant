# Use Bundler
begin
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

module Radiant
  def self.loaded_via_gem?
    false
  end
  
  def self.app?
    true
  end
  
  Version = '0.9.rails3'
end
