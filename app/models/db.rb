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
        array.map(&:to_s).map{ |e| "'#{e}'"  }
      end

      def get_list(table)
        query("SELECT * FROM #{table}")
      end

      def get_by_id(table, id)
        query("SELECT * FROM #{table} WHERE id = #{escape(id)}").first
      end

      def add(table, params)
        query("INSERT INTO #{table}
              (#{params.keys.join(',')})
              VALUES (#{format(params.values).join(',')})")
      end

      def update(table, params, id)
        query("UPDATE #{table} SET
               #{params.map { |k, v| "#{k.to_s} = '#{v}'" }.join(', ')}
              WHERE id = '#{escape(id)}'")
      end

      def delete(table, id)
        query("DELETE FROM #{table} WHERE id = #{escape(id)}")
      end

      def load(rules, params)
        data = {}
        rules.each { |rule| data[rule[:name]] = escape(params[rule[:name]]) }
        data
      end

    end
  end
end
