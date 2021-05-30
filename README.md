# README

Application for getting scores of github authors by combination of pull requests statistics in specified repository.

### Ruby version
Ruby 2.4.3
Rails 5.2

### System dependencies
Clone repository on your local PC and run *bundle* in the app repository for installing dependencies.

### Database creation
Replace DB 'username' and 'password' in *app/config/database.yml* with your DB credentials.
Run `rails db:create db:migrate` after instaling app and all dependencies. Than run Rails console `rails c` in app directory.

### Database initialization
Not necessary

### How to use app
The app doesn't have a view part. You can check all functionality from rails console in OS terminal.
After app installation run rails console and try to execute next test line of code:

`::Scorecard::Creator.new('rails', 'rails', '2018-12-01','2020-12-31').create`

Format:

`::Scorecard::Creator.new('owner', 'repo', 'start date of range', 'end date of range').create`

If you don't specify dates the date range of the last week will be applied by default.
You can specify any public owner/repo values because app doesn't have authorization feature for getting statistics from private repositories.

The rate of each author is calculated as the average of the sum of each component multiplied by the corresponding points:

`((pulls_coune * PULL_POINTS) + (reviews_count * REVIEW_POINTS) + (comments_count * COMMENT_POINTS)) / 3`

As a result you will get the table with number of most rated authors with additional column *rate*. You can change the number of rows and score points in */app/services/scorecard/creator.rb*. By default number of table rows equals 5.

App saves some information about owner, repo and contributors for future handling. 
App doesn't have function of saving score results due a lack of requirements for logic.
