# SqlitePrintTable

The `sqlite_print_table` gem is used to print a formatted table from a sqlite database using a SQL query.
Note: This works in addition to the `sqlite3` gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sqlite3'
gem 'sqlite_print_table'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sqlite3
    $ gem install sqlite_print_table

## Usage

Example: 

```
require "sqlite3"
require "sqlite_print_table"

@db = SQLite3::Database.open "ny_airbnb_data"
@db.print_table("
                SELECT name, host_name, price, neighbourhood, room_type
                FROM listings 
                LIMIT 25;
                ")
```

# Options

- `:guide_preference` (boolean, default: true) - shows guides
- `:guide_tolerance` (integer, default: 3) - shows guide if the number of columns is over the tolerance
- `:width_tolerance` (integer, default: 2) - shows guide if width of column is above
- `:margin` (integer, default: 3) - adjusts the margin on the left of the table

Exapmle With Options

```
require "sqlite3"
require "sqlite_print_table"

@db = SQLite3::Database.open "ny_airbnb_data"
@db.print_table("
                SELECT name, host_name, price, neighbourhood, room_type
                FROM listings 
                LIMIT 25;
                ", guide_tolerance: 4, width_tolerance: 5, margin: 10 )
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
