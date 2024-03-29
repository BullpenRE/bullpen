# Welcome to the Bullpen Rails App

### Introduction
This app was intended to replace a no-code bubble.io app for [Bullpen Real Estate](https://www.bullpenre.com/) but 
a few weeks before the scheduled release it was decided for business reasons to not move forward with the replacement, and instead use it as a portfolio piece for the
awesome team of engineers and designers that made it happen. It is almost fully built (about 90%) but has a few minor pieces of functionality missing.

You can see this application in action on Heroku at http://bullpen-staging.herokuapp.com. NOTE: In order to prevent potential abuse this application cannot send out any emails. In order to test the user experience 
for a freelancer, use me@freelancer.com with password `Password1!`. To see the view of an employer you can use me@employer.com also with the password `Password1!`.

### The Team
A big thank you to everyone below who contribute
d to this project!

 - [Roger Graves](https://www.linkedin.com/in/roginc/): Application architecture, database and models programming, devops, server-ops, and project management.
 - [Ron Graves](https://www.linkedin.com/in/ron-graves-029928108/): Product design, Boostrap configuration, [styleguide](https://bullpen-staging.herokuapp.com/styleguide) creation and CSS programming.
 - [Svetlana Borozenets](https://www.linkedin.com/in/svetlana-borozenets-8827a515a/): Lead Software Engineer, did most of the development work on visible features (controllers, views, services & javascript).
 - [Jane Butsanova](https://www.linkedin.com/in/evgenia-butsanova-804a3a210/): QA Engineer, assisted in design, managed our manual regression test process.
 - [Maryna Mikhaylovskaya](https://www.linkedin.com/in/maryna-mikhaylovskaya/): QA Engineer, helped test new features and identify missing functionality.
 - [Oleksii Sokalo](https://www.linkedin.com/in/oleksii-sokalo-97589393/): Full stack engineering and led the team on Stripe integration issues.
 - [Galina Kravchuk](https://www.linkedin.com/in/galina-kravchuk-6b79a2b5/): Full stack engineering and was in charge of Mixpanel and ActiveCampaign integration.
 - [Tetyana Goncharenko](https://www.linkedin.com/in/tetyana-goncharenko-42a507a4/): Full stack engineering and was responsible for our automated integration test suite ([Cypress](https://www.cypress.io/)).
 - [Olga Goncharenko](https://www.linkedin.com/in/olga-goncharenko-91466a194/): Added automated integration tests using Cypress.

### The Stack

The Bullpen application is built on:
 * Ruby 2.7.2
 * Rails 6.1.1
 * postgresql 10.0 or higher
 
### Code Quality 
[![Maintainability](https://api.codeclimate.com/v1/badges/2b1724876c36b5bb29c3/maintainability)](https://codeclimate.com/repos/5f5ff58f6f8e8901a000376a/maintainability) 

### Getting Started with this Codebase (Mac)
This assumes you have [RVM](http://rvm.io/), postgresql, redis and yarn installed.

1. In your primary workspace directory run `$ git clone git@github.com:BullpenRE/bullpen.git` in terminal.
2. Enter into the new directory: `$ cd bullpen`
3. At this point you might be prompted to update your Ruby version. If so, follow the instructions in terminal.
4. Enter the following command: `$ rvm list` -- verify that your currently selected Ruby version is 2.7.2.
5. If you had to update your Ruby version in step 3, exit and enter the current directory: `$ cd ..`, then `$ cd bullpen`.
6. Enter the following command: `$ rvm gemset list` -- verify that the current gemset is bullpen.
7. Install missing gems in your currently selected gemset by running `$ bundle`
8. Install NodeJS packages: `$ yarn install`
9. Instantiate the local database: `$ rails db:create`
10. Seed the database: `$ rails db:seed`
11. Open a new tab and start redis: `$ redis-server`. If you have an error such as Address already in use you can use command `$ redis-server --port 6360`
12. Open a new tab and start sidekiq: `$ sidekiq -C 'config/sidekiq.yml'`
13. Test it out: `$ rails s` and then navigate to http://localhost:3000


### Test Coverage

After getting the code base running locally you can run `$ rspec` to run all unit tests. You should have redis running in the background before running some tests.
Follow steps 1-5 below to run the Cypress integration tests. 
[Here is what it looks like in action](https://www.loom.com/share/ee8a3eaa721345d0926f17d7e8ea7dae).

1. Install Cypress:

   `$ yarn add cypress --dev` 

2. Create test db:

   `$ RAILS_ENV=test bin/rake db:create db:schema:load`

   `$ RAILS_ENV=test rails db:seed` - if needed

3. Run test db migration if needed:

   `$ RAILS_ENV=test rails db:migrate`

   or

   `$ RAILS_ENV=test rails db:test:prepare`

4. Open 3 separate tabs in terminal and run each of the folloing. User Ctrl-C to stop them:

   `$ bundle exec rails server -e test -p 5017 --pid tmp/pids/server5017.pid`

   `$ redis-server`

   `$ sidekiq -C './config/sidekiq.yml'`

5. Open one more tab, then run the cypress dashboard:
   
   `$ yarn cypress open --project ./test` 
