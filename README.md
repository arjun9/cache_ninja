<div>
  <img src="./assets/logo.png" alt="Cache Ninja Logo" width="100" style="border-radius: 20px; display:inline; vertical-align: middle;">
</div> <br>

# Cache Ninja
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Downloads](https://img.shields.io/gem/dt/cache_ninja.svg)](https://rubygems.org/gems/cache_ninja)
[![Gem Version](https://badge.fury.io/rb/cache_ninja.svg)](https://badge.fury.io/rb/cache_ninja)

**Cache Ninja**  is the ultimate solution for safely and efficiently caching associations in your Ruby on Rails applications. While association caching is typically discouraged, there are specific scenarios where it's not just beneficial but essential for optimizing performance. **Cache Ninja**  has been rigorously tested and is currently employed in our production-grade servers, making it the most reliable gem for association caching in Rails.

- [Use Cases](#use-cases)
- [Installation](#installation)
- [Getting Started](#getting-started)
- [Usage](#usage)
  - [Cache Objects](#cache-objects)
  - [Cache Associations](#cache-associations)
  - [Cache Multiple Associations](#cache-multiple-associations)
  - [No need to worry about Cyclicity](#no-need-to-worry-about-cyclicity)
  - [Cache Associations with Options](#cache-associations-with-options)
- [Using Cache Ninja in your existing Rails Application](#using-cache-ninja-in-your-existing-rails-application)
- [Contributing](#contributing)
- [License](#license)

## Use Cases
In the world of Ruby on Rails, association caching has often been viewed with caution. However, there are use cases where association caching can be a game-changer, and that's where **Cache Ninja** comes into play. Here are some examples of when association caching can be beneficial:

* **Focus on Business Logic**:
Caching associations with **Cache Ninja** means you can shift your focus from low-level optimization to what truly matters: your application's business logic. It empowers developers to streamline their code and deliver better user experiences without worrying about performance bottlenecks.

* **Tangible Performance Boost**:
In our own experience, implementing **Cache Ninja** led to a remarkable 5x reduction in latency for heavily used models. This kind of performance enhancement can be a game-changer for applications that require lightning-fast responses.

* **Effortless Integration**:
**Cache Ninja** seamlessly integrates into your Rails application, ensuring that you can start reaping the benefits of association caching without unnecessary complexity. The gem is well-documented, making it easy to get started and unlock its potential.

* **Safe and Proven in Production**:
**Cache Ninja** is not just another gem; it's a battle-tested solution that powers our internal production-grade servers. We've put it through its paces to ensure that it delivers the utmost in performance and reliability. When it comes to caching associations, **Cache Ninja** is the gem you can trust.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cache_ninja'
```

```shell
bundle install
```

Or install it yourself as:

```shell
gem install cache_ninja
```

## Getting Started

After installing Cache Ninja, you need to include it in your models. To get started, add the following line to your model class:

```ruby
class User < ApplicationRecord
  include CacheNinja

  # ...
end
```

**Cache Ninja** is now ready to use in your model.

## Usage

**NOTE: Any changes made to an object, removes its data and the data of its associated objects from the cache. This is done to ensure that the cached data is always up-to-date and consistent.**

### Cache Objects:
Wherever you include **CacheNinja**, it will dynamically create `fetch_cached()` method on the instances of that particular model (it takes id as parameter). You can use it as such:

```ruby
class User < ApplicationRecord
  include CacheNinja

  # ...
end
```

```ruby
user = User.fetch_cached(1)
```

### Cache Associations:
Once Cache Ninja is included in your model, you can start caching associations using the `cache_assoc` method. Here's an example:

```ruby
class User < ApplicationRecord
  include CacheNinja

  # Cache the 'teams' association
  cache_assoc :teams

  # ...
end
```

This will dynamically create a method `cached_teams` which can be then used for reducing database queries and improving performance. Now you can access the cached association i.e. `cached_teams` data in this case, as such:

```ruby
user = User.first
user.cached_teams
```

### Cache Multiple Associations:
You can also cache multiple associations at once:

```ruby
class User < ApplicationRecord
  include CacheNinja

  # Cache the 'teams' and 'posts' associations
  cache_assoc :teams, :posts

  # ...
end
```

This will dynamically create the methods `cached_teams`, `cached_posts` which can be then used for reducing database queries and improving performance. Now you can access the cached associations i.e. `cached_teams`, `cached_posts` data in this case, as such:

```ruby
user = User.first
user.cached_teams
user.cached_posts
```

### No need to worry about Cyclicity:
Cache Ninja takes care of cyclicity in associations. For example, if you have a `User` model which has many `Posts` and each `Post` belongs to a `User`, then you can cache both associations without worrying about cyclicity. Here's an example:

```ruby
class User < ApplicationRecord
  include CacheNinja

  # Cache the 'posts' and 'comments' associations
  cache_assoc :posts, :comments

  # ...
end

class Post < ApplicationRecord
  include CacheNinja

  # Cache the 'user' association
  cache_assoc :user

  # ...
end
```

### Cache Associations with Options:
Suppose for the above example you want to cache user's posts but not cache user data for a particular post. You can do that by passing options to `cache_assoc` method. Here's an example:

```ruby
class User < ApplicationRecord
  include CacheNinja

  # Cache the 'posts' and 'comments' associations
  cache_assoc :posts, :comments

  # ...
end

class Post < ApplicationRecord
  include CacheNinja

  # Cache the 'user' association
  cache_assoc :user, disable: true

  # ...
end
```

## Using Cache Ninja in your existing Rails Application

1. Once you have installed Cache Ninja, you can include it in `ApplicationRecord` class as such:

```ruby
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include CacheNinja
end
```

2. Now you can start caching associations in your models as such:

```ruby
class User < ApplicationRecord
  # Cache the 'teams' association
  cache_assoc :teams

  # ...
end
```

3. Now search for the instances in your application where you are using something similar to `user.teams` and replace it with `user.cached_teams` as such:

```ruby
def index
  @users = User.all
  @teams = @users.collect(&:cached_teams)
end
```

NOTE: This gem is not intended to be a replacement for solving *n+1 queries*. It is intended to be used in scenarios where you have a lot of associations and have no option but to cache them in order to improve performance.

## Contributing
In case of use cases not covered by this gem, please feel free to open an issue or a pull request. You can even write to `arjun.verma8412@gmail.com`. We would love to hear your feedback and suggestions.

Bug reports and pull requests are welcome on GitHub at https://github.com/arjun9/cache_ninja. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/arjun9/cache_ninja/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CacheNinja project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/cache_ninja/blob/master/CODE_OF_CONDUCT.md).

