# Dynamodb::Test

Some basic tests against Amazon's Dynamodb.

## Installation

Add this line to your application's Gemfile:

    gem 'dynamodb-test'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynamodb-test

## Usage

Create a .env containing your amazon keys

    AMAZON_KEY=your_amazon_key
		AMAZON_SECRET=your_amazon_secret


Run the `dynamodb commands` command to get a list of commands.

    $ dynamodb commands

### Useful commands

1. tables - will show you all the tables you have
1. table <name> - will show you the full info for one table
1. items <table name> - iterates on all items in a given table (do not run on large tables)
1. add <table name> <key=value> [<key1=value>] - adds an item to a table
1. rm <table name> <primary key> <range key>


## Seeded Setup

If you don't already have a set of tables you can create a seeded set of tables like this

    $ dynamodb create_seed_table test-table
		...wait...
		$ dynamodb seed test-table


## Contributing

1. Fork it ( http://github.com/jkamenik/dynamodb-test/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
