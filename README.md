# cloudimages-rundeck
* Cloud Image Information Provider for RunDeck
* Polls Cloud Provider API's for available images

## Supported Providers
* DigitalOcean

## Background
This project's initial purpose is/was to retrieve a list of available base images to feed into a RunDeck job.  It can be tedious to update jobs after a new image is created.
You can also pass a filter query parameter which will search (case insensitive) for matching images.  You can pass multiple things to search for using commas to seperate them, e.g. ```^ubuntu,^centos```

**NOTE:** This API should **NOT** be exposed to the world unless you plan to secure it with a reverse-proxy or something.  It is intended to only be bound to `localhost` on the same server as RunDeck.

## Running as a Service
You'll likely want to run this as a service, `SystemD` or `Upstart` will likely be your friend in this regard.

## Security
You should lock down permissions on all configuration files in this project to only the user which this runs as...

To run this project securely, **DON'T** run it as the RunDeck user.

## Caching
This leans on `rack-cache` to serve as a caching mechanism.  The objective here was to make sure we don't pummel the Chef API with redundant queries.
* Timeout can be configured via the `cache_timeout` setting. **Default:** *30 seconds*


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudimages-rundeck'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudimages-rundeck

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bdwyertech/cloudimages-rundeck. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
