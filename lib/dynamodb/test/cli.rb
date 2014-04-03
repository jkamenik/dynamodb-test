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
        puts "commands - Lists commands"
        puts "tables   - Shows all tables"
      end
      
      def tables(*args)
        db.tables.each do |table|
          puts "#{table.name}: #{table.status}"
          puts "\tRead:  #{table.read_capacity_units}"
          puts "\tWrite: #{table.write_capacity_units}"
          puts "\tItems: #{table.item_count}"
          puts "\tKey:   #{table.hash_key.name} - #{table.hash_key.type}"
          puts "\tRange: #{table.range_key.name} - #{table.range_key.type}"
        end
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
      
      def seed(*args)
        table = get_table(args.shift)
        
        table.items.create(
          account_id: 'test',  # primary key
          page:       'foo',   # range
          content:    '<html></html>'
        )
      end
      
      private
      
      def get_table(name)
        db.tables[name].load_schema
      end
    end
  end
end