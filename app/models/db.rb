require 'eventmachine'
require 'mysql2/em'
module Blog
  module Models
    class Db

      DB = Mysql2::Client.new(App.get_settings.database)

      def query(query)
        DB.query(query)
      end

      def escape(string)
        DB.escape(string)
      end

      def format(array)
        array.map(&:to_s).map{ |e| "'" + e + "'" }
      end

      def get_list(entity)
        query("SELECT * FROM #{entity}")
      end

      def add(entity, params)
        query("INSERT INTO #{entity}
              (#{params.keys.join(',')})
              VALUES (#{format(params.values).join(',')})")
      end

      def load(rules, params)
        data = {}
        rules.each { |rule| data[rule[:name]] = params[rule[:name]] }
        data
      end

    end
  end
end
