require 'clockwork'
require_relative '../../config/boot'
require_relative '../../config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'astronomania-staging import job', at: '05:00') do
    Astromania::Import.call(environment: :staging)
  end
end
