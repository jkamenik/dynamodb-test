module Dynamodb
  module Test
    class Cli
      attr_reader :db
      
      def initialize
        @db = dynamo_db = AWS::DynamoDB.new(
          :access_key_id => ENV['AMAZON_KEY'],
          :secret_access_key => ENV['AMAZON_SECRET']
        )
      end
      
      def run(*args)
        method = args.shift.to_sym
        self.public_send method, *args
      rescue => e
        puts "Error: #{e.to_s}"
        usage
      end
      
      def usage(*args)
        puts "#{$0} <command> <args>"
        puts "  commands - Lists commands"
      end
      
      def commands(*args)
        puts "commands                        - Lists commands"
        puts "tables                          - Shows all tables"
        puts "table <name>                    - Shows full info on one table"
        puts "rmtable <name>                  - Removes a table"
        puts "items <table name>              - Shows all items in a given table (do not run on large tables)"
        puts "count <table name>              - Shows the number of items in table"
        puts "add <table name> <key=value>... - Add a new item"
        puts "rm <table name> <primary key>   - Removes an item"
        puts "create_seed_table <table name>  - Creates a new table"
        puts "seed <table name>               - Seeds a table with values"
      end
      
      def tables(*args)
        db.tables.each do |table|
          puts "#{table.name}: #{table.status}"
        end
      end
      
      def table(*args)
        table = get_table(args.shift)
        
        puts "#{table.name}: #{table.status}"
        puts "\tRead:  #{table.read_capacity_units} units"
        puts "\tWrite: #{table.write_capacity_units} units"
        puts "\tItems: #{table.item_count}"
        puts "\tKey:   #{table.hash_key.name} - #{table.hash_key.type}"
        puts "\tRange: #{table.range_key.name} - #{table.range_key.type}" unless table.range_key.nil?
      end
      
      def rmtable(*args)
        name = args.shift
        puts "Deleting table #{name.inspect}"
        table = get_table(name)
        table.delete
        while table.status == :deleting
          print '.'
          sleep 1
        end
        puts 'done'
      end
      
      def items(*args)
        table = args.shift
        
        get_table(table).items.each do |item|
          item.attributes.each do |key,value|
            puts "#{key}: #{value.inspect}"
          end
          puts "-"*20
        end
      end
      
      def create_seed_table(*args)
        name   = args.shift
        reads  = args.shift || 1
        writes = args.shift || 1

        puts "Creating table #{name.inspect}, this could take awhile"
        table = db.tables.create(name, Integer(reads), Integer(writes),
          hash_key: {url: :string}
        )
        while table.status == :creating
          print '.'
          sleep 1
        end
        puts 'done'
      end
      
      def seed(*args)
        table = get_table(args.shift)

        pages      = %W(index contact_us about_us)
        microsites = %W(ehc wildbird test)
        
        microsites.each do |site|
          pages.each do |page|
            table.items.create(
              url: "#{site}/#{page}",
              content: "<html></html>"
            )
          end
        end
        puts "Items: #{table.item_count}"
      end
      
      def add(*args)
        table      = args.shift
        attributes = {}
        
        args.each do |item|
          key,value = item.split('=')
          attributes[key] = value
        end
        
        get_table(table).items.create(attributes).attributes.each do |key,value|
          puts "#{key}: #{value.inspect}"
        end
      end
      
      def rm(*args)
        table = args.shift
        
        get_table(table).items[*args].delete
      end
      
      private
      
      def get_table(name)
        db.tables[name].load_schema
      end
    end
  end
end