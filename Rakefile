require File.expand_path('../config/application', __FILE__)

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

Rails::Application.load_tasks

unless Rake::Task.task_defined? "radiant:release"
  Dir["#{RADIANT_ROOT}/lib/tasks/**/*.rake"].sort.each { |ext| load ext }
end
