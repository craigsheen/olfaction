# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Rails.logger = Le.new('0ce254cb-6115-4a78-90ac-c48100d46459', :debug => true, :local => true)
