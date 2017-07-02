require 'clockwork'
require_relative '../../config/boot'
require_relative '../../config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  # every(1.day, 'midnight.job', :at => '00:00')
  every(1.second, 'test.job') { puts 'running test job' }
end
