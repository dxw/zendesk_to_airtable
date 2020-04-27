$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "lib")

require "zendesk_to_airtable"

require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:spec)

task default: %i[standard spec]

namespace :project_populator do
  task :import do
    ZendeskToAirtable.new.run!
  end
end
