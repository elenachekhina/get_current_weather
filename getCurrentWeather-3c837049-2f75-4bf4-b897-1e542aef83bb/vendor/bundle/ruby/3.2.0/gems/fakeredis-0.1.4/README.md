# FakeRedis [![Build Status](http://travis-ci.org/guilleiguaran/fakeredis.png)](http://travis-ci.org/guilleiguaran/fakeredis)
This a fake implementation of redis-rb for machines without Redis or test environments


## Installation

Install the gem:

    gem install fakeredis

Add it to your Gemfile:

    gem "fakeredis"


## Usage

You can use FakeRedis::Redis similary as you use redis gem:

    require "fakeredis"
    
    redis = FakeRedis::Redis.new
    
    >> redis.set "foo", "bar"
    => "OK"
    
    >> redis.get "foo"
    => "bar"

Read [redis-rb](https://github.com/ezmobius/redis-rb) documentation and
[Redis](http://redis.io) homepage for more info about commands


## Contributing to FakeRedis

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.


## Copyright

Copyright (c) 2011 Guillermo Iguaran. See LICENSE for
further details.
