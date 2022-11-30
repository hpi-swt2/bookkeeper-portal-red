# Bookkeeper Portal — 🟥 Edition

`dev` branch: [![CI & CD](https://github.com/hpi-swt2/bookkeeper-portal-red/actions/workflows/ci_cd.yml/badge.svg?branch=dev)](https://github.com/hpi-swt2/bookkeeper-portal-red/actions/workflows/ci_cd.yml)

`main` branch: [![CI & CD](https://github.com/hpi-swt2/bookkeeper-portal-red/actions/workflows/ci_cd.yml/badge.svg?branch=main)](https://github.com/hpi-swt2/bookkeeper-portal-red/actions/workflows/ci_cd.yml)
, deployed app: [Heroku](https://bookkeeper-red-main.herokuapp.com)

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

A web application for keeping track of items and loaning them out, written in [Ruby on Rails](https://rubyonrails.org/).
Created in the [Scalable Software Engineering course](https://hpi.de/plattner/teaching/winter-term-2022-23/scalable-software-engineering.html) at the HPI in Potsdam.

## Development Guide

### Commit Guideline

We use the [Conventional Commits Specification v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) for writing commit messages. Please refer to the website for specific instructions.

Since we don't have many different modules / services, we do not specify a commit scope (write `fix: ...` instead of `fix(module): ...`).

We use the recommended commit types from the specification, namely:

- `feat:` A code change that introduces a **new feature** to the codebase (this correlates with MINOR in Semantic Versioning)
- `fix:` A code change that **patches a bug** in your codebase (this correlates with PATCH in Semantic Versioning)
- `refactor:` A code change that **neither fixes a bug nor adds a feature**
- `build:` Changes that **affect the build system** or external dependencies (example scopes: pip, npm)
- `ci:` Changes to **CI configuration** files and scripts (examples: GitHub Actions)
- `docs:` **Documentation only** changes
- `perf:` A code change that **improves performance**
- `test:` Adding missing **tests** or correcting existing tests

### Git Workflow

We practice [Scaled Trunk-Based Development](https://trunkbaseddevelopment.com/#scaled-trunk-based-development) with a `dev` branch as trunk. Hence our feature branches are short-lived and merged back into `dev` as soon as possible. After consultation with POs, `dev` can be merged into `main` at any time to create a production release.

Our branches are named `{team-initals}/{feature-name}`, eg. `gdm/print-qrcode`. This allows folder grouping by team and easy identification of the feature being worked on.

Each PR requires at least one approved review before it can be merged into `dev`. Each PR branch must be rebased on `dev` before merging (or have `dev` merged into the PR branch before).

### Code & Style Guide

We follow the [Ruby Style Guide](https://rubystyle.guide/), which is enforced by RuboCop. Please use an editor extension to ensure that Rubocop offenses are highlighted directly.

Rubocop also allows to automatically fix offenses:

```shell
bundle exec rubocop --auto-correct
```

### Employed Frameworks

- [Stimulus JS](https://stimulus.hotwired.dev) as the default JavaScript framework, augmenting HTML
- [Bootstrap](https://getbootstrap.com/docs/5.2) for layout, styling and [icons](https://icons.getbootstrap.com/)
- [Devise](https://github.com/heartcombo/devise) library for authentication
- [FactoryBot](https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#defining-factories) to generate test data
- [Capybara](https://github.com/teamcapybara/capybara#the-dsl) for feature testing
- [shoulda](https://github.com/thoughtbot/shoulda-matchers#matchers) for additional RSpec matchers

### Cheat Sheets

- [FactoryBot](https://devhints.io/factory_bot)
- [Testing using Capybara](https://devhints.io/capybara)

### Setup

- `bundle exec rails db:migrate RAILS_ENV=development && bundle exec rails db:migrate RAILS_ENV=test` Migrate both test and development databases
- `rails assets:clobber && rails assets:precompile` Redo asset compilation

### Testing

- `bundle exec rspec` Run the full test suite
  - `--format doc` More detailed test output
  - `-e 'search keyword in test name'` Specify what tests to run dynamically
  - `--exclude-pattern "spec/features/**/*.rb"` Exclude feature tests (which are typically fairly slow)
- `bundle exec rspec spec/<rest_of_file_path>.rb` Specify a folder or test file to run
- `bundle exec rspec --profile` Examine run time of tests
- Code coverage reports are written to `coverage/index.html` after test runs (by [simplecov](https://github.com/simplecov-ruby/simplecov))

### Debugging

- `debug` anywhere in the code to access an interactive console
- `save_and_open_page` within a feature test to inspect the state of a webpage in a browser
- `rails c --sandbox` Test out some code in the Rails console without changing any data
- `rails dbconsole` Starts the CLI of the database you're using
- `bundle exec rails routes` Show all the routes (and their names) of the application
- `bundle exec rails about` Show stats on current Rails installation, including version numbers

### Generating

- `rails g migration DoSomething` Create migration _db/migrate/\*\_DoSomething.rb_
- `rails generate` takes a `--pretend` / `-p` option that shows what will be generated without changing anything

## Local Development Setup

Ensure you have access to a Unix-like environment through:

- Your local Linux / MacOS installation
- Using the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install) (WSL)
- Using a VM, e.g. [Virtualbox](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com/)
- Using a [docker](https://docs.microsoft.com/en-us/windows/wsl/install) container

### Application Setup

- `ruby --version` Ensure Ruby v2.7.4 using [rbenv](https://github.com/rbenv/rbenv) or [RVM](http://rvm.io/)
- `sqlite3 --version` Ensure [SQLite3 database installation](https://guides.rubyonrails.org/getting_started.html#installing-sqlite3)
- `bundle --version` Ensure [Bundler](https://rubygems.org/gems/bundler) installation (`gem install bundler`)
- `bundle config set without 'production' && bundle install` Install gem dependencies from `Gemfile`
- `rails db:migrate` Setup the database, run migrations
- `rails assets:precompile && rails s` Compile assets & start dev server (default port _3000_)
- `bundle exec rspec --format documentation` Run the tests (using [RSpec](http://rspec.info/) framework)

### OIDC Setup

> Note: This is only required in a production environment. There are hard-coded
> OIDC client credentials in this project which are configured to work in a
> local environment.

- [register](https://oidc.hpi.de) a new application with the redirect URI
  `http://{BASE_URL}/users/auth/openid_connect/callback` (adapt the base URL
  accordingly).
- set the following variables in your rails environment:
    - `OPENID_CONNECT_CLIENT_ID`
    - `OPENID_CONNECT_CLIENT_SECRET`
