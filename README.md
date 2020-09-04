# Welcome to the Bullpen App

The Bullpen application is built on:
 * Ruby 2.7.1
 * Rails 6.0.3.2
 * postgresql 10.0 or higher
 * Code complexity and security monitoring by CodeClimate (pending)

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
9. Install Ruby from terminal using RVM: `$ rvm install 2.7.1`
10. Install posgtresql from terminal: `$ brew install postgresql` and follow on screen instructions (very important)
11. Create postgresql superuser postgres: `$ createuser postgres -s`

### Getting Started with this Codebase
Once your machine is set up for Rails development you can do the following to get the app running locally.
1. In your primary workspace directory run `$ git clone git@github.com:BullpenRE/bullpen.git` in terminal.
2. Enter into the new directory: `$ cd bullpen`
3. At this point you might be prompted to update your Ruby version. If so, follow the instructions in terminal.
4. Enter the following command: `$ rvm list` -- verify that your currently selected Ruby version is 2.7.1.
5. If you had to update your Ruby version in step 3, exit and enter the current directory: `$ cd ..`, then `$ cd bullpen`.
6. Enter the following command: `$ rvm gemset list` -- verify that the current gemset is *bullpen*.
7. Install missing gems in your currently selected gemset by running `$ bundle`
8. Instantiate the local database: `$ rails db:create`
9. Test it out: `$ rails s` and then navigate to http://localhost:3000



### Beginner's Guide to Changing Code

Every time you are ready to start work, do the following terminal commands in the bullpen directory:

        $ git smart-pull
        $ bundle
        $ rails db:migrate

Then if your server isn't started yet:

        $ rails s

At this point you can point your browser to http://localhost:3000/ and start development work.
To stop the server click CNTL-C.

To check to make sure your code changes didn't break anything critical:

        $ rspec

Green dots are good, red F's are bad. Note that sometimes other people may have broken the build, so use your best judgement if the automated test errors were caused by your code or not (for example if you undo changes and re-run the test). You can also compare your local errors to that on our CI server (pending).

To push your code changes to the repo:

        $ git add .
        $ git commit -am "Message describing what changes you made [#XXXXXXX]"
        $ git push origin master

Note: replace XXXXXXX with the issue tracker story ID (very important).

If you run into problems pushing, it's probably because somebody pushed other commits between the time you last pulled and the current time that you want to push:

        $ git smart-pull
        $ git push origin master

Switching between master and a private branch:

        $ git checkout XXXXXX
        $ git checkout master (to go back to master)

where XXXXXX is the branch name. Then you'll want to use this branch name instead of master for things, i.e.

        $ git pull origin XXXXXXX
           or
        $ git push origin XXXXXXX

When you are ready to move your branch to master:

        $ git checkout master
        $ git merge XXXXXXX

This will attempt to migrate your branch differences into master.


### Cherry Picking
If you need to copy over a commit from one branch to another without merging:

1. Copy the SHA of the commit you want to copy over (the program "tig" is good for this which can be installed via brew on a Mac).
2. Go to the branch you want to copy the commit to `$ git checkout [BRANCHNAME]`
3. Use cherry-pick to copy over the commit: `$ git cherry-pick [SHA]`

NOTE: If you have more than one commit to copy over, do the cherry-pick commands in the same order as they were committed.
Also be careful about doing this if there is a high possibility of there being a conflict.
See [this link](https://ariejan.net/2010/06/10/cherry-picking-specific-commits-from-another-branch/) for more information.

### Code Submissions and Reviews

1. Any significant feature should be done in a separate branch.

        $ git checkout -b bp-123-description-of-issue

    To get the branch name, open up the story in [Linear.app](https://linear.app/bullpen/team/BP/active) and then copy it using `cmd`+`shift`+`.`

2. When a feature is complete and tests pass, push to github.

        $ git push origin bp-X-branch-name

3. If you want to update your new branch with changes from master (very recommended), do the following:

        $ git checkout master
        $ git pull origin master
        $ git checkout bp-X-branch-name
        $ git merge master

    Then resolve conflicts manually and push to your new_branch_name again

        $ git push origin bp-X-branch-name

4. When all work in branch is done, create a pull request:
    - Go to https://github.com/bullpenre/bullpen
    - Set base branch to master and compare-to branch to the branch where you've done your work
    - Click "Create pull request"
    - Add a description of the pull request and add pivotal tracker IDs (similar to commit messages)



=== Dev Environment Server Database Reset

Use the following rake task to reset your local database to what is on staging. Before running these commands:

1. Close out any servers or consoles running that might be connecting to your local DB.
2. Make sure that your branch is set to what is on staging (most likely master).
3. Make sure you ahve wget installed. If not you can get it using homebrew via `brew install wget`.

            $ heroku pg:backups capture -a cp-business-staging
            Backing up DATABASE to XXXX... done
            $ wget `heroku pg:backups public-url -a cp-business-staging` -O latest.dump
            $ rake db:import

The `db:import` command can also specify an older *.dump file to import like so:

            $ rake db:import[2017-06-22_production_scrubbed.dump]

After the new database is installed you can switch to a different branch. Don't forget to run migrations after switching to another branch (if there are new ones).
NOTE: If you get a Rails 5 error `ActiveRecord::ProtectedEnvironmentError: You are attempting to run a destructive action against your 'production' database` while doing an import, you can bypass this by running `$ rails db:environment:set`.

### Heroku Deploy Setup

1. Make sure the heroku toolbelt is installed from https://toolbelt.heroku.com/
2. Restart terminal and cd into the bullpen directory, then run the following:

        $ heroku login
        $ git remote add bullpen-staging git@heroku.com:bullpen-staging.git

