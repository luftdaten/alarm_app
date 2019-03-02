# App.Luftdaten.info App
## A Particular Matter Notification App

This Rails 5 (5.0.0.1) app integrated:

* [Devise] - for authentication.

* [Active Admin] - for controlling the content of site through admin panel.

* [Devise invitable] - for inviting the user from the admin panel to join the application.

* [semantic ui] - for look and feel of application with glyphicons.

* [letter opener] - for view the content of email in the browser itself.

* [exception_notification] - for sending the exception email to recipients in production mode.

* Flash messages display.

* [meta_request]- for development (for google chrome [rails panel])

* .gitignore for rails app.

## Development environment:

* Ruby version (2.3.0).

* Rails 5 (5.0.0.1).

* Mysql (Development) and Postgresql (Production)

## Setup

1. Do git checkout followed by git archive by

```sh
$ git archive master | tar -x -C /somewhere/else
```
2. cd into that directory.
3. I am using mysql database for development. if you are using any other update your Gemfile for corresponding database adapter.
4. Update database configurations in database.yml.

```sh
bundle install
rails db:create db:migrate db:seed
rails s
```


## Platform already live at: https://app.luftdaten.info

[![Screenshot der Live-App](https://github.com/luftdaten/alarm_app/raw/master/docs/_static/2019-03-02-startpage.jpg)](https://github.com/luftdaten/alarm_app/raw/master/docs/_static/2019-03-02-startpage.jpg)


### Thanks goes to the technical base of the project the openair.cologne app!



[Devise]: <https://github.com/plataformatec/devise>

[Active Admin]: <https://github.com/activeadmin/activeadmin>

[Devise invitable]: <https://github.com/scambra/devise_invitable>

[semantic ui]: <http://semantic-ui.com>

[letter opener]: <https://github.com/ryanb/letter_opener>

[exception_notification]: <https://github.com/smartinez87/exception_notification>

[meta_request]: <https://github.com/dejan/rails_panel/tree/master/meta_request>

[rails panel]: <https://github.com/dejan/rails_panel>

[admin panel]: <http://localhost:3000/admin/admins>

[default]: <http://localhost:3000/users/sign_in>