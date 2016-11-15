# Setting up environment

 Required: **JRuby 9.1.5.0** (Ruby 2.3.1), **Rails 4.2.1**

### Install JRuby (using RVM)

1. If no RVM is installed, install it with:

  `\curl -sSL https://get.rvm.io | bash -s stable`

  More information: https://rvm.io/rvm/install


2. Install specific JRuby version. Go to app root directory and run in console:

  `rvm use jruby-9.1.5.0 --install`



### Install all the gems

  `bundle install`


### Setting up a database

  1. Delete the `config/database.yml` file.
  2. Locate `database_example.yml` and rename it to `database.yml`
  3. Run `bundle exec rake db:migrate`

### Additional information (not neeeded for the set-up)

  The splice engine jar file is located in `/lib` directory

  If making some changes to the splice engine itself, copy the new compiled file and overwrite it in lib directory, like:
  `~/spliceengine/db-client/target/db-client-2.0.1.34-SNAPSHOT.jar` to the `/lib` directory


# Starting up the splicemachine and the app

  Make sure splice engine is up and running:

  1. `cd ~/spliceengine/`

  2. `./start-splice-cluster` (only for the first time). Run `./start-splice-cluster -b`on every other time

    `./start-splice-cluster -h`, for any addtional information


##### Possible issues:

  If there are issues with running a splice cluster, you might need to add next line into your `~/.bashrc` file:

  `export LD_LIBRARY_PATH=/usr/local/lib`

##### Notes:

  On linux, if splice cluster is not run on the first time (after running a `./start-splice-cluster -b`), stop the execution, and run `./start-splice-cluster -b` again.


# Testing

  Before running tests or benchmarks start splice cluster first: `./start-splice-cluster -b`

#### Run tests

  `bundle exec rspec spec/`

#### Run real server-client test:

  *Note: Some of the SQL commands will assume that there are records in database, like where, update etc. , so in `bundle run rails c`, and create a single record with: `Company.create(name: 'Company')` before running the tests.*

  1. Run the server: `be puma -p 3000 -t 16:16 -e production`
  2. Run the benchmark `ab -n 10000 -c 1000 -r http://localhost:3000/benchmarks/method_where`

#### Run benchmark on single SQL command

  `bundle exec rake benchmark:models`

# Switching between Ruby and JRuby

  In this app **Ruby**  is used for *MySQL* and **JRuby** for *Splice/Derby*

  If you want to run the code against `ruby` code and test the app with it, open file `.ruby-version` and change any text in it to `ruby-2.3.1`, or any other ruby version. Return to the previous directory with (`cd ..`), and re-enter the app directory by `cd base-jruby-splice` (in order to refresh the settings)

  The database settings for `ruby` is in `database_ruby.yml`. No need to replace or delete the `database.yml`, just modify the `database_ruby.yml` file with your settings.

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

