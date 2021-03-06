# Microverse Project Title - Authentication [Collaborative Project]
Ruby on Rails

### Introduction.

This assignment consists of using the bcrypt gem to have a first approach at authentication in rails. You will build an application that allows users to create posts and the authors of the posts are displayed only if as a User you are logged in.

COMMON MISTAKE HINT: The remember_me token the project describes consists of storing a hash in a cookie and using it to determine in a user is logged in. Do not confuse it with the Remember me [ ] checkbox that many websites show. That is a more complex solution, which is not required here.

Full task description: https://www.theodinproject.com/courses/ruby-on-rails/lessons/authentication.

### Microverse Adjustments

You should do the “Project 1: Ruby on Rails Tutorial” individually, and then you will complete the project Members Only together with your partner. Once you are finished with this project, continue working together with your coding partner on the next project. You must still remain in a video call with your partner during your independent work.

Please submit only "Project 2: Members Only!"

ONCE AGAIN - COMMON MISTAKE HINT: The remember_me token the project describes consists of storing a hash in a cookie and using it to determine in a user is logged in. Do not confuse it with the Remember me [ ] checkbox that many websites show. That is a more complex solution, which is not required here.

### Project specific
Use application layout for sign-in and sign-out links.
In addition - make sure that users can also create their account by adding a Sign up feature.
[HINT] as lesson about associations is still ahead of you - for setting up association between user and posts remember that User has many posts and Post belongs to user.

###  Ruby version

rbenv 2.6.5


###  System dependencies

Rails 6.0.1

Yarn 1.19.1

Ubuntu 18.04 & below

###  Database creation
sqlite3

###  Database initialization

###  Services (job queues, cache servers, search engines, etc.)

###  Deployment instructions

1. Open the terminal.

2. Enter git clone https://github.com/geraldgsh/members-only

3. Navigate to the cloned repository.

4. Migrate database with this command "rails db:migrate"

5. Populate user database with this command "rails db:seed"

6. Run "bundle install" command to install all relevant gems

7. Run "rails server" command and open browser using "localhost:3000"

8. Sign in with default login (email: example@odin.org, password: foobar)


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
$bundle install
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
# /app/models/user.rb

class User < ApplicationRecord
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  validates :email, presence: true
end
```

6. Go into your Rails console and create a sample user to make sure it works properly. It probably looks something like: User.create(:name => "foobar", :email => "foo@bar.com", :password => "foobar", :password_confirmation => "foobar")
```sh
$rails console

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
# Sessions and Sign In
## Now let’s make sure our users can sign in.

1. Create a sessions_controller.rb and the corresponding routes. Make “sign in” links in the layout as necessary.
```sh
rails generate controller Sessions

 create  app/controllers/sessions_controller.rb
      invoke  erb
      create    app/views/sessions
      invoke  test_unit
      create    test/controllers/sessions_controller_test.rb
      invoke  helper
      create    app/helpers/sessions_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/sessions.scss

```
2. Fill in the #new action to create a blank session and send it to the view.
```sh
class SessionsController < ApplicationController
	def new
	end
end
```
3. Build a simple form with #form_for to sign in the user at app/views/sessions/new.html.erb. Verify that you can see the form.
```sh
<h1>Sign in</h1>

<%= form_for(:session, url: sessions_path) do |f| %>

  <%= f.label :email %>
  <%= f.text_field :email %>

  <%= f.label :password %>
  <%= f.password_field :password %>

  <%= f.submit "Sign in", class: "btn btn-large btn-primary" %>
<% end %>
```

4. We want to remember that our user is signed in, so you’ll need to create a new string column for your User table called something like :remember_token which will store that user’s special token.
```sh
rails generate migration add_remember_token_to_users
      invoke  active_record
      create    db/migrate/20191119200826_add_remember_token_to_users.rb

class AddRememberTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :remember_token, :string
    add_index  :users, :remember_token
  end
end

rails db:migrate
== 20191119194524 CreateUsers: migrating ======================================
-- create_table(:users)
   -> 0.0014s
== 20191119194524 CreateUsers: migrated (0.0014s) =============================

== 20191119200826 AddRememberTokenToUsers: migrating ==========================
-- add_column(:users, :remember_token, :string)
   -> 0.0011s
-- add_index(:users, :remember_token)
   -> 0.0007s
== 20191119200826 AddRememberTokenToUsers: migrated (0.0019s) =================

```

5. When you create a new user, you’ll want to give that user a brand new token. Use a #before_create callback on your User model to:
  1. Create a remember token (use SecureRandom.urlsafe_base64 to generate a random string)
  2. Encrypt that token (with the Digest::SHA1.hexdigest method on the stringified (#to_s) version of your token)
  3. Save it for your user.

```sh
# /app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
.
.
.
def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
```

6. Create a couple of users to populate your app with. We won’t be building a sign up form, so you’ll need to create new users via the command line. Your #before_create should now properly give each newly created user a special token.
```sh
User.all
   (0.3ms)  SELECT sqlite_version(*)
  User Load (0.4ms)  SELECT "users".* FROM "users" LIMIT ?  [["LIMIT", 11]]
=> #<ActiveRecord::Relation [#<User id: 1, name: "Foobar", email: "example@odin.org", password_digest: [FILTERED], created_at: "2019-11-19 20:29:02", updated_at: "2019-11-19 20:29:02", remember_token: "504ee00cea75ca3c834a9abfbe5a0a21280a5873">, #<User id: 2, name: "Bettie Cartwright III", email: "example-1@microverse.org", password_digest: [FILTERED], created_at: "2019-11-19 20:29:04", updated_at: "2019-11-19 20:29:04", remember_token: "cad3a75dbc2928800b99d6befff11b751e8f7180">, #<User id: 3, name: "Eliz Farrell PhD", email: "example-2@microverse.org", password_digest: [FILTERED], created_at: "2019-11-19 20:29:04", updated_at: "2019-11-19 20:29:04", remember_token: "8e0e466d157537071db62fb7b446968d5442d643">, #<User id: 4, name: "Rutha Schaefer", email: "example-3@microverse.org", password_digest: [FILTERED], created_at: "2019-11-19 20:29:04", updated_at: "2019-11-19 20:29:04", remember_token: "a8aa2e33f85dacc65125b11263d7374d62fff535">, #<User id: 5, name: "Leoma Marquardt", email: "example-4@microverse.org", password_digest: [FILTERED], created_at: "2019-11-19 20:29:05", updated_at: "2019-11-19 20:29:05", remember_token: "7ddc6a064468b6d5fdf651f109e0f7e8d0e5d9db">, #<User id: 6, name: "Jarrod Becker", email: "example-5@microverse.org", password_digest: [FILTERED], created_at: "2019-11-19 20:29:05", updated_at: "2019-11-19 20:29:05", remember_token: "b84bc36b137bff818711bec56c7795e0768a4672">, #<User id: 7, name: "Spencer McLaughlin", email: "example-6@microverse.org", password_digest: [FILTERED], created_at: "2019-11-19 20:29:05", updated_at: "2019-11-19 20:29:05", remember_token: "8f195b52bd19354d03831e774c2123a7b6b1e2db">, #<User id: 8, name: "Demarcus Bayer MD", email: "example-7@microverse.org", password_digest: [FILTERED], created_at: "2019-11-19 20:29:06", updated_at: "2019-11-19 20:29:06", remember_token: "570998c472f65fac181797c5af6c850dd6881b07">, #<User id: 9, name: "Travis Botsford", email: "example-8@microverse.org", password_digest: [FILTERED], created_at: "2019-11-19 20:29:06", updated_at: "2019-11-19 20:29:06", remember_token: "65a2c163fa03f864eaa4da4d369bba3361bcdd07">, #<User id: 10, name: "Brinda Gutkowski", email: "example-9@microverse.org", password_digest: [FILTERED], created_at: "2019-11-19 20:29:06", updated_at: "2019-11-19 20:29:06", remember_token: "cc6d6fedc39cef1c761be694cab606fec68bb30e">]>

```

7. Now fill in the #create action of your SessionsController to actually create the user’s session. The first step is to find the user based on their email address and then compare the hash of the password they submitted in the params to the hashed password stored in the database (using #authenticate). See Chapter 8 with questions but try not to immediately copy verbatim – you’re doing this to learn.
```sh
class SessionsController < ApplicationController
	.
  .
  .
	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			flash[:success] = 'Thank you for signing in!'
			sign_in user
			redirect_to root_path        
		else
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end
end

```

8. Once you’ve verified that the user has submitted the proper password, sign that user in.
```sh
It work!
```

9. Create a new method in your ApplicationController which performs this sign in for you. Give the user a new remember token (so they don’t get stolen or stale). Store the remember token in the user’s browser using a cookie so whenever they visit a new page, we can check whether they are signed in or not. Use the cookies.permanent “hash” to do this.

10. Create two other helpful methods in your ApplicationController – one to retrieve your current user (#current_user) and another to set it (#current_user=(user)). Retrieving your current user should use the ||= operator – if the current user is already set, you should return that user, otherwise you’ll need to pull out the remember token from the cookie and search for it in your database to pull up the corresponding user. If you can’t find a current_user, return nil.

11. Set your current user whenever a user signs in.
```sh
# /app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end

```

12. Build sign out functionality in your SessionsController#delete action which removes the current user and deletes the remember token from the cookie. It’s best if you make a call to a method (e.g. #sign_out) in your ApplicationController instead of just writing all the functionality inside the SessionsController.
```sh
# /app/controllers/sessions_controller.rb

class SessionsController < ApplicationController
  .
  .
  .
	def destroy
		sign_out
		redirect_to root_path
	end
end

```

13. Create a link for signing out which calls the #delete method of your session controller. You’ll need to spoof the DELETE HTTP method, but that’s easily done by passing #link_to the option :method => :delete.
```sh
# /config/routes.rb

Rails.application.routes.draw do
  .
  .
  .
  match '/signout', to: 'sessions#destroy',     via: 'delete'
end
```

### Authentication and Posts

1 .Create a Post model and a Posts controller and a corresponding resource in your Routes file which allows the [:new, :create, :index] methods.
```sh
$rails generate model Post title:string body:text
      invoke  active_record
      create    db/migrate/20191119210824_create_posts.rb
      create    app/models/post.rb
      invoke    test_unit
      create      test/models/post_test.rb
      create      test/fixtures/posts.yml

$rails generate controller posts

      create  app/controllers/posts_controller.rb
      invoke  erb
      create    app/views/posts
      invoke  test_unit
      create    test/controllers/posts_controller_test.rb
      invoke  helper
      create    app/helpers/posts_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/posts.scss

# ../config/routes.rb

Rails.application.routes.draw do
.
.
  resources :Posts, only:  [:new, :create, :index]
  root 'posts#index'
.
.
.

$ rails db:migrate
/home/ggoh/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/railties-6.0.1/lib/rails/app_loader.rb:53: warning: Insecure world writable dir /mnt/c in PATH, mode 040777
== 20191119200826 AddRememberTokenToUsers: migrating ==========================
-- add_column(:users, :remember_token, :string)
   -> 0.0244s
-- add_index(:users, :remember_token)
   -> 0.0061s
== 20191119200826 AddRememberTokenToUsers: migrated (0.0369s) =================

== 20191119210824 CreatePosts: migrating ======================================
-- create_table(:posts)
   -> 0.0031s
== 20191119210824 CreatePosts: migrated (0.0080s) =============================

# ../app/models/post.rb 

class Post < ActiveRecord::Base
  belongs_to :user

  validates :title,  presence: true
  validates :body, presence: true
end

```

2. Atop your Posts Controller, use a #before_action to restrict access to the #new and #create methods to only users who are signed in. Create the necessary helper methods in your ApplicationController.
```sh
# /app/controller/post_controllers.rb

class Post < ApplicationRecord
  before_action :signed_in_user, only: [:new, :create]

  # before filter/action
   def signed_in_user
    unless signed_in?
      redirect_to signin_url
    end
  end
end
```

3. For your Posts Controller, prepare your #new action.
```sh

# ../app/controller/posts_controller.rb

class PostsController < ApplicationController
  def new
    @Post = Post.new
  end
end

```

4. Write a very simple form in the app/views/posts/new.html.erb view which will create a new Post.
```sh

# ../app/views/posts/new.html.erb

<h1>New Post</h1>

<%= form_for @post do |f| %>

<p>
  <%= f.label :title %> <br/>
  <%= f.text_field :title %>
</p>
<p>
  <%= f.label :body %><br />
  <%= f.text_area :body %>
</p>

<p>
  <%= f.submit %>
</p>

<% end %>

```

5. Make your corresponding #create action build a post where the foreign key for the author (e.g. user_id) is automatically populated based on whichever user is signed in. Redirect to the Index view if successful.
```sh
$ rails generate migration AddForeignKeyToPost user:references

      invoke  active_record
      create    db/migrate/20191119213057_add_foreign_key_to_post.rb

$ rails db:migrate

== 20191119213057 AddForeignKeyToPost: migrating ==============================
-- add_reference(:posts, :user, {:foreign_key=>true})
   -> 0.0204s
== 20191119213057 AddForeignKeyToPost: migrated (0.0215s) =====================

# ../app/models/post.rb

class Post < ApplicationRecord
  belongs_to :user


# ../app/models/user.rb
class User < ApplicationRecord
  has_many :posts

# ../app/controller/post_controller.rb

class PostsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create]
.
.
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to root_path
  end

  private

    def post_params
      params.require(:post).permit(:title, :body)  
    end
    
end

# ../app/controller/sessions_controller.rb

class SessionsController < ApplicationController
.
.
.
  def create
    redirect_to root_path
.
.
. 
```

6. Fill out the #index action of the PostsController and create the corresponding view. The view should show a list of every post.
```sh
# ../app/controller/post_controller.rb

class PostsController < ApplicationController
.
.
.
  def index
    @Post = Post.all
  end
.
.
.

# ../app/views/posts/index.html.erb

<div class="float-right">
  <% if signed_in? %>
  <%= link_to "(#{current_user.name}) Sign out", signout_path, method: "delete" %>
  <% else %>
    <%= link_to 'Sign in', signin_path %>
  <% end %>
</div>

<h1>Members Only Posts</h1>

<% @posts.each do |post| %>
  <% if signed_in? %>
    <p class="float-right">
      Posted by:
      <%= post.user.name %>
    </p>
  <% end %>
  <h4 class="float-left"><%=post.title %></h4>  
  <p class="clear"><%= post.body %></p>
<% end %>

<% if signed_in? %>
  <%= link_to "Create a Post", new_post_path %>
<% end %>

```

7. Now add logic in your Index view to display the author’s name, but only if a user is signed in.
```sh
# ../app/controller/post_controller.rb

class PostsController < ApplicationController
.
.
.
  private
    def signed_in_user
      unless signed_in?
        redirect_to signin_url
      end
    end
.
.
.

```

8. Sign in and create a few secret posts.

9. Test it out – sign out and go to the index page. You should see a list of the posts but no author names. Sign in and the author names should appear. Your secrets are safe!

### Extra stuff 

1. Added flash message feature for valid and invalid login
```sh

# ./app/views/layout/application.html.erb

<div>
  <% flash.each do |message_type, message| %>
    <%= content_tag(:div, message, class: "alert alert-#{message_type}") %>
  <% end %>
  <%= yield %>
</div>
```

2. Create user signup feature;
```sh
rails generate controller Users new
      create  app/controllers/users_controller.rb
       route  get 'users/new'
      invoke  erb
      create    app/views/users
      create    app/views/users/new.html.erb
      invoke  test_unit
      create    test/controllers/users_controller_test.rb
      invoke  helper
      create    app/helpers/users_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/users.scss

# ../app/config/routes.rb

Rails.application.routes.draw do
.
.
  match    '/signup',  to: 'users#new', via: 'get'
  match   '/signup',  to: 'users#create', via: 'post'
  resources :users
end

# ../app/controllers/users_controller.rb
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = "Account created successfully"
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
    end
end


```

### Source

https://www.theodinproject.com/courses/ruby-on-rails/lessons/authentication

### Github Repo

https://github.com/geraldgsh/members-only

### Authors

* [@Christian](https://github.com/jcromerohdz)

* [@Gerald](https://github.com/geraldgsh)
