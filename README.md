# Welcome to the Bullpen App

The Bullpen application is built on:
 * Ruby 2.7.2
 * Rails 6.1.1
 * postgresql 10.0 or higher
 * Code complexity and security monitoring by CodeClimate (pending)
 
##### Current Grades
[![Maintainability](https://api.codeclimate.com/v1/badges/2b1724876c36b5bb29c3/maintainability)](https://codeclimate.com/repos/5f5ff58f6f8e8901a000376a/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2b1724876c36b5bb29c3/test_coverage)](https://codeclimate.com/repos/5f5ff58f6f8e8901a000376a/test_coverage)

### Useful Mac goodies that are highly recommended
1. For pretty and customizable command line info, including branch and whether you have uncommited changes or not: https://github.com/bobthecow/git-flow-completion/wiki/Install-Bash-git-completion
2. For a fast command line way to browse the most recent git commits: `$ brew install tig`
3. https://www.jetbrains.com/ruby/download


### New Development Machine Install (Mac)
The following assumes you haven't installed the following on your machine yet. 
  * XCode
  * Homebrew
  * Git
  * RVM
  * Postgresql

_Note: After installing something new it's generally a good idea to quit and restart terminal._

1. Install the latest version of XCode from the App store, run `$ xcode-select --install`
2. Install the latest version of Homebrew: http://brew.sh
3. Install Git on Mac using homebrew: `$ brew install git`
4. Set your GIT username from terminal: `$ git config --global user.name "YOUR NAME"`
5. Set your GIT email address from terminal: `$ git config --global user.email "YOUR EMAIL ADDRESS"`
6. Generate and add SSH keys your Github account by following the instructions at https://help.github.com/articles/generating-ssh-keys/
7. Install GPG using homebrew: `$ brew install gpg` (May be needed for RVM in next step)
8. Install the latest version of RVM: https://rvm.io. The command is probably something like `$ \curl -sSL https://get.rvm.io | bash -s stable`.
9. Install Ruby from terminal using RVM: `$ rvm install 2.7.2`
10. Install the latest version of NVM: https://github.com/nvm-sh/nvm.
11. Install NodeJS from terminal using NVM: `nvm install node` and Yarn `npm install -g yarn`
12. Install posgtresql from terminal: `$ brew install postgresql` and follow on screen instructions (very important)
13. Create postgresql superuser postgres: `$ createuser postgres -s`

### Getting Started with this Codebase
Once your machine is set up for Rails development you can do the following to get the app running locally.
1. In your primary workspace directory run `$ git clone git@github.com:BullpenRE/bullpen.git` in terminal.
2. Enter into the new directory: `$ cd bullpen`
3. At this point you might be prompted to update your Ruby version. If so, follow the instructions in terminal.
4. Enter the following command: `$ rvm list` -- verify that your currently selected Ruby version is 2.7.2.
5. If you had to update your Ruby version in step 3, exit and enter the current directory: `$ cd ..`, then `$ cd bullpen`.
6. Enter the following command: `$ rvm gemset list` -- verify that the current gemset is *bullpen*.
7. Install missing gems in your currently selected gemset by running `$ bundle`
8. Install NodeJS packages: `$ yarn isntall`
8. Instantiate the local database: `$ rails db:create`
9. Test it out: `$ rails s` and then navigate to http://localhost:3000
10. Open a new tab and start redis: `$ redis-server`. If you have an error such as `Address already in use` you can use command `$ redis-server --port 6360`
11. Open a new tab and start sidekiq: `$ sidekiq`

### Running the application locally and making changes
Every time you are ready to start work, do the following terminal commands in the bullpen directory:

        $ git smart-pull
        $ bundle
        $ rails db:migrate

Then if your server isn't started yet:

        $ rails s
        $ redis-server
        $ sidekiq

At this point you can point your browser to http://localhost:3000/ and start development work.
To stop the server click CNTL-C.

To check to make sure your code changes didn't break anything critical:

        $ rspec

Green dots are good, red F's are bad. Note that sometimes other people may have broken the build, so use your best judgement if the automated test errors were caused by your code or not (for example if you undo changes and re-run the test). You can also compare your local errors to that on our CI server (pending).

### How to add libraries to Webpacker

1. First install it using yarn, like so: `$ yarn add packagename`
2. Require it in _app/javascript/packs/application.js_.

Depending on how involved it is, it might require additional setup, for example in *config/webpack/environment.js*. Do a google search like *"add packagename to rails 6 webpacker"*

### How to attach your commits to the Linear.app story
To push your code changes create a new branch that follows the patter `bp-X-story-description` where `X` is the Linear.app story number. When viewing the [story in Linear.app](https://linear.app/bullpen/team/BP/active) do `cmd`+`shift`+`.` to copy this branch name, then paste it when creating a new local branch.

        $ git checkout -b [paste branch name from Linear.app]
        $ git add .
        $ git commit -am "Message describing what changes you made"
        $ git push origin [branch name]

### Keeping Synced with Master
At least once per day merge master into your story branch:

        $ git checkout master
        $ git smart-pull
        $ git checkout [your local branch name]
        $ git merge master
        $ git push origin [your local branch name]

If you have merge conflicts after merging master, work with your teammates to resolve them.

### Backing Up and Restoring Development Databases
The following rake command will import a database dump file containing a `*.dump` extension. 
This file must be in the /bullpen directory. If you have multiple `*.dump` files it will choose the one with the most 
recent timestamp (the one that was most recently written).

        $ rake db:import

In order to export your local development database to a `*.dump` file, run the following command:

        $ rake db:export

The name of the exported file will include a timestamp and look something like `2020-11-11_development.dump`.
In order to specify a name while importing or exporting you can pass along a name, both for importing and exporting:

        $ rake db:import\[rogers_test_database.dump\]
        $ rake db:export\[my_database.dump\]


### Cherry Picking
If you need to copy over a commit from one branch to another without merging:

1. Copy the SHA of the commit you want to copy over (the program "tig" is good for this which can be installed via brew on a Mac).
2. Go to the branch you want to copy the commit to `$ git checkout [BRANCHNAME]`
3. Use cherry-pick to copy over the commit: `$ git cherry-pick [SHA]`

NOTE: If you have more than one commit to copy over, do the cherry-pick commands in the same order as they were committed.
Also be careful about doing this if there is a high possibility of there being a conflict.
See [this link](https://ariejan.net/2010/06/10/cherry-picking-specific-commits-from-another-branch/) for more information.

### Code Submissions and Reviews

When all work in for a story is done, create a pull request:

- Go to https://github.com/bullpenre/bullpen
- Set base branch to master and compare-to branch to the branch where you've done your work
- Click "Create pull request"
- Add a description of the pull request (similar to commit messages)

After a pull request is made, Linear.app will automatically link it to your story (and visa versa) based on the branch name.

### Workflow and Coding Standards
 * See our our [workflow guide](https://docs.google.com/document/d/1CHKSaYzk3-_K1hLxOlezKNXMxHzEnlSjo0TaFZZuFog/edit#).
 * Use Ruby on Rails best practices with [these additions and exceptions](https://docs.google.com/document/d/1r5R6SxVuz9TDE1hGc3yU9ocJxywwVi-lnmlQOEv9TI4/edit#heading=h.71frplvdndqk).
 * After creating a pull request either fix or address all issues brought up by CodeClimate: [link to decision](https://bullpenre.slack.com/archives/C01A6KTQ35Z/p1600271307031300)
 * Don't create custom CSS. Inline in views is OK: [link to decision](https://bullpenre.slack.com/archives/C01A6KTQ35Z/p1600107544007100)
 * See our test coverage rules [here](https://docs.google.com/document/d/1qlU-_xOt6tgCBWO_8m4q4FJmYxc5gPgOmjfq91sVong/edit).
 * For complex Javascript use classes via our Javascript guide (coming soon): [link to decision](https://bullpenre.slack.com/archives/C01A6KTQ35Z/p1601048239003000) 

### Heroku Deploy Setup
Our [staging server](https://bullpen-staging.herokuapp.com) is currently set to automatically deploy the master branch after pull requests are merged. In case you need to do manual pushes:

1. Make sure the heroku toolbelt is installed from https://toolbelt.heroku.com/ _(optional)_
2. Restart terminal and cd into the bullpen directory, then run the following: _(optional)_

        $ heroku login
        $ git remote add bullpen-staging git@heroku.com:bullpen-staging.git

3. Run `$ git push bullpen-staging master` to deploy master. Before doing this you may need to switch Heroku's deploy from Github to Heroku Git [here](https://dashboard.heroku.com/apps/bullpen-staging/deploy/github).

### Cypress integration tests

1. Install Cypress:

        $ yarn add cypress --dev
        
2. Create test db:

        $ RAILS_ENV=test bin/rake db:create db:schema:load 
        $ RAILS_ENV=test rails db:seed - if needed
        
3. Run test db migration if needed:
  
        $ RAILS_ENV=test rake db:migrate
        
4. In terminal of project or RubyMine IDE start puma server on port:5017 as second separate and parallel to localhost:3000 development process:
    
        $ bundle exec rails server -e test -p 5017 --pid tmp/pids/server5017.pid   
        Use Ctrl-C to stop
        
5. Open cypress dashboard:

        $ yarn cypress open --project ./test
        
6. Getting started:

 https://docs.cypress.io/guides/getting-started/installing-cypress.html#System-requirements;
 https://docs.cypress.io/guides/getting-started/testing-your-app.html#Step-1-Start-your-server
 https://blog.simplificator.com/2019/10/11/setting-up-cypress-with-rails/
 https://www.toolsqa.com/cypress/what-is-cypress/

7. Best Practice: 
Use data-* attributes to provide context to your selectors and isolate them from CSS or JS changes [here](https://docs.cypress.io/guides/references/best-practices.html)

8. How to use: https://docs.cypress.io/faq/questions/using-cypress-faq.html

