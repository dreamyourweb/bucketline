# Be sure to restart your server when you modify this file.

if Rails.env.development?
  HvO::Application.config.session_store :cookie_store, key: '_HvO_session', :domain => "lvh.me"
elsif Rails.env.test?
  HvO::Application.config.session_store :cookie_store, key: '_HvO_session', :domain => "example.com"
elsif Rails.env.production?
  HvO::Application.config.session_store :cookie_store, key: '_HvO_session', :domain => "bucketline.nl"
end
  
# HvO::Application.config.session_store :cookie_store, key: '_HvO_session', :domain => :all

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# HvO::Application.config.session_store :active_record_store
