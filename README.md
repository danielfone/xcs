# Contact Sync Refactoring App

This is a simple app that renders a list of contacts from the database,
and allows a user to sync these with Xero.

There are basically 4 files to refactor:

* app/contacts/contacts_controller.rb
* app/views/contacts/index.html.erb
* app/models/contacts.rb
* app/jobs/contact_pull_job.rb

Most but not quite all of the behaviour is spec'd, so while your refactoring
should be fairly safe, its possible you could introduce a bug in and the suite
is still green. Don't worry too much, it's the thought that counts.


## Getting Started

This was developed under Ruby 2.4.1, but should work for any modern Ruby.

1. Get the secrets file and put it in config/secrets.yml
2. Check everything is working:
```
# start postgres server somewhere
bin/setup && bin/rspec
```
3. Run the server if you like: `bin/rails server`
