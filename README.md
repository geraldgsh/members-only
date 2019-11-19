# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

### Basic Setup

1. Think about and spec out how to set up your data models for this application. You’ll need users with the usual simple identification attributes like name and email and password but also some sort of indicator of their member status. They’ll need to create posts as well. Given what you know about passwords, you’ll be using a :password_digest field instead of a :password field.
```sh
rails new members-only

```

2. Create your new members-only Rails app and Github repo. Update your README.
```sh
Done!

https://github.com/geraldgsh/members-only
```

3. Start by migrating and setting up your basic User model (no membership attributes yet).
```sh
$ rails generate model User name:string email:string password_digest:string

      invoke  active_record
      create    db/migrate/20191119194524_create_users.rb
      create    app/models/user.rb
      invoke    test_unit
      create      test/models/user_test.rb
      create      test/fixtures/users.yml

$ rails db:migrate

== 20191119194524 CreateUsers: migrating ======================================
-- create_table(:users)
   -> 0.0047s
== 20191119194524 CreateUsers: migrated (0.0058s) =============================
```

4. Include the bcrypt-ruby gem in your Gemfile. $ bundle install it. (note: This might just be bcrypt)
```sh
 bundle install
Fetching gem metadata from https://rubygems.org/.............
Fetching gem metadata from https://rubygems.org/.
Resolving dependencies...
Using rake 13.0.1
.
.
.

```

5. Add the #has_secure_password method to your User file.
```sh
class User < ApplicationRecord
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
```

6. Go into your Rails console and create a sample user to make sure it works properly. It probably looks something like: User.create(:name => "foobar", :email => "foo@bar.com", :password => "foobar", :password_confirmation => "foobar")
```sh
>> User.all
   (0.8ms)  SELECT sqlite_version(*)
  User Load (0.4ms)  SELECT "users".* FROM "users" LIMIT ?  [["LIMIT", 11]]
=> #<ActiveRecord::Relation []>
>> user = User.create(:name => "foobar", :email => "foo@bar.com", :password => "foobar", :password_confirmation => "foobar")
   (0.1ms)  begin transaction
  User Create (2.6ms)  INSERT INTO "users" ("name", "email", "password_digest", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["name", "foobar"], ["email", "foo@bar.com"], ["password_digest", "$2a$12$IAy0J5GkiOTh5N4wK/mOau7bUVH3x0EULJZUlANQtJNnVaY10MiaW"], ["created_at", "2019-11-19 19:55:35.750679"], ["updated_at", "2019-11-19 19:55:35.750679"]]
   (2.9ms)  commit transaction
=> #<User id: 1, name: "foobar", email: "foo@bar.com", password_digest: [FILTERED], created_at: "2019-11-19 19:55:35", updated_at: "2019-11-19 19:55:35">
```

7. Test the #authenticate command which is now available on your User model (thanks to #has_secure_password) on the command line – does it return the user if you give it the correct password?
```sh
>> user.authenticate('foobar')
=> #<User id: 1, name: "foobar", email: "foo@bar.com", password_digest: [FILTERED], created_at: "2019-11-19 19:55:35", updated_at: "2019-11-19 19:55:35">
>> user.authenticate('fooba')
=> false
```
