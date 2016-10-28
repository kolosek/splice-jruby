== README


# Install pre-requirements

If you dont have rvm setup make sure you go through the steps to setup rvm in the following website:
http://installrails.com

It is very important that the versions of the below outline products should have the proper major version.

* Ruby version
  2.3.1

* Jruby Version
  9.1.5.0

  If JRuby is not installed, go to app root directory and run in console:

  `rvm use jruby-9.1.5.0 --install`

* Rails Version
  4.2.1

* Install all the gems

  `bundle install`

* System dependencies
  Just run the app. No additional changes needed.

  The jar file is located in `/lib` directory

  If making some changes copy and overwrite new modified file:
  ~/spliceengine/db-client/target/db-client-3.0.0.10-SNAPSHOT.jar to the /lib directory


# Setting up a database

  Splicemachine doesn't play well with automatic creating of tables.
  Go to `database.yml`:
  - Uncommet the commented lines, and delete `adapter: postgresql`
  - Change adapter from `jdbc` to `jdbcderby`
  - Run `bundle exec rake db:migrate RAILS_ENV=test`
  - After all the tables are created, change adapter back to `jdbc`


# Starting up the splicemachine and the app
  Make sure splicemachine is up and running:

  `cd ~/spliceengine/`

  `./start-splice-cluster` (only on the first time, run `./start-splice-cluster -b` every other time)

  `./start-splice-cluster -h`, for any addtional information


# Run tests

  `bundle exec rspec spec/`

# Additional information:

  If you want to run the code against `ruby` code and test the app with it, open file `.ruby-version` and change it to `ruby-2.3.1`, or any other ruby version

  The database settings for `ruby` is in `database_ruby.yml`. No need to replace `database.yml`, just modify the `database_ruby.yml` file with your settings.

# Implementation of Rails on CentOS (centos-release-6-8.el6.centos.12.3.x86_64)

* sudo yum groupinstall -y 'development tools'
* gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
* curl -L get.rvm.io | bash -s stable (In case the keys are not present then the above key would be shown )
* source ~/.profile
* rvm install jruby
  in case ruby gems is not installed (rvm ruby gems latest)
* gem install rails -v 4.0.0
* gem install bundle
* git clone https://github.com/splicemachine/splice-community-sample-code.git
* navigate to “tutorial-rails” and run "bundle install"
* which jruby
  whatever directory comes substitute bin for lib and put the client driver file there.
  In my case i for ~/.rvm/rubies/jruby-9.0.5.0/bin/jruby
  ~/.rvm/rubies/jruby-9.0.5.0/lib

