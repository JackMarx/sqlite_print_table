require "sqlite_print_table/version"

class SQLite3::Database
  def print_table(sql_command_string, options={})
    # dependent on #prepare, #columns, #each methods from sqlite3 gem

    raise ArgumentError.new("WARNING: This method only allows SQL Queries that start with 'SELECT'") unless sql_command_string.split[0].upcase == "SELECT"
    data = self.prepare(sql_command_string)
    columns = data.columns
    columns_length = columns.length

    width_tolerance = options[:width_tolerance] || 2
    raise ArgumentError.new("WARNING: width_tolerance option must be an integer greater than 0") unless width_tolerance.is_a?(Integer) && width_tolerance > 0

    guide_tolerance = options[:guide_tolerance] || 3
    raise ArgumentError.new("WARNING: guide_tolerance option must be an integer greater than 0") unless guide_tolerance.is_a?(Integer) && guide_tolerance > 0

    raise ArgumentError.new("WARNING: guide_preference option must be a boolean") unless options[:guides] == nil || options[:guides] == false || options[:guides] == true
    guide_preference = options[:guide_preference] == false ? false : true

    raise ArgumentError.new("WARNING: margin option must be an integer greater than 0") unless options[:margin] == nil || options[:margin].is_a?(Integer) && options[:margin] > 0
    left_margin = " " * (options[:margin] || 3)

    header_count = columns.map { |header| header.to_s.length }

    storage = data.map { |row|
      header_count.length.times do |index|
        width = row[index].to_s.length
        header_count[index] = width if width > header_count[index]
      end
      row
    }

    header_line = columns.map.with_index {|column, index| " " + column.to_s.upcase.ljust(header_count[index] + 1) + " "}.join("|")

    puts ""
    puts left_margin + header_line
    puts left_margin + "-" * header_line.length

    storage.each do |row|
      puts left_margin + row.map.with_index { |this_column, index| 
        this_column_value = this_column.to_s
        padding = columns_length > guide_tolerance && this_column_value.length < header_count[index] - width_tolerance && guide_preference ? "_" : " "
        formatted_column = this_column ? this_column_value + " " : "NIL "
        " " + formatted_column.ljust(header_count[index] + 1, padding) + " "
      }.join("|")
    end
    puts ""
    "Table Printed: (#{storage.length} lines)"
  end
end
