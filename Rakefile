$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "lib")

require "zendesk_to_airtable/project_populator"

require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:spec)

task default: %i[standard spec]
