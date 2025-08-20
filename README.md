# README

Setup Instructions
Prerequisites

Ruby 3.4.5
Rails 8.0.2.1
Ubuntu/WSL environment

Installation

Clone the repository
Run bundle install to install dependencies
Set up your database (SQLite by default)

Running Tests
To execute the test suite for the device assignment service:
RAILS_ENV=test bundle exec rspec spec/services/assign_device_to_user_spec.rb