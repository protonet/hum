source 'http://rubygems.org'

RAILS_VERSION  = '~> 3.0.4'
DM_VERSION     = '~> 1.1.0'

gem 'activesupport',        RAILS_VERSION, :require => 'active_support'
gem 'actionpack',           RAILS_VERSION, :require => 'action_pack'
gem 'actionmailer',         RAILS_VERSION, :require => 'action_mailer'
gem 'railties',             RAILS_VERSION, :require => 'rails'
gem 'rails',                RAILS_VERSION

gem 'dm-rails',             DM_VERSION
gem 'dm-sqlite-adapter',    DM_VERSION
gem 'dm-migrations',        DM_VERSION
gem 'dm-types',             DM_VERSION
gem 'dm-validations',       DM_VERSION
gem 'dm-constraints',       DM_VERSION
gem 'dm-transactions',      DM_VERSION
gem 'dm-aggregates',        DM_VERSION
gem 'dm-timestamps',        DM_VERSION
gem 'dm-observer',          DM_VERSION

# Component requirements
gem 'haml'
gem 'sass'
gem 'hpricot'
gem 'ruby_parser'
gem 'compass', ">= 0.11.5"
gem "headjs-rails"
gem 'stamp'
gem 'typhoeus'
#gem 'deploy', :git => "git@github.com:protonet/deploy.git", :groups => [:development]
#gem 'exception_notification'

# Testing
group :test do
  gem "libnotify"
  gem "guard"

  gem 'dm-sweatshop'

  #unit tests
  gem 'bacon'
  gem "rr"

  #functional tests
  gem 'capybara'
end

