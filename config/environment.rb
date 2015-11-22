# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

=begin
ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :user_name            => 'iwheyapp@gmail.com',
    :password             => 'iwheycgd',
    :authentication       => 'plain',
    :enable_starttls_auto => true  
}
=end