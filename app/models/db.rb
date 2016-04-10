require 'eventmachine'
require 'mysql2/em'
module Blog
  module Models
    class Db
      # TODO: make bind ability in query function

      DB = Mysql2::Client.new(ENV['DATABASE_URL'] ? ENV['DATABASE_URL'] : App.get_settings.database)

      def query(query)
        DB.query(query)
      end

      def escape(string)
        DB.escape(string)
      end

      def format(array)
        array.map(&:to_s).map { |e| "'#{e}'" }
      end

      def get_list(table)
        query("SELECT * FROM #{table} ORDER BY id DESC")
      end

      def get_by_id(table, id)
        query("SELECT * FROM #{table} WHERE id = #{escape(id)}").first
      end

      def add(table, params)
        query("INSERT INTO #{table}
              (#{params.keys.join(',')})
              VALUES (#{format(params.values).join(',')})")
        DB.last_id.to_s
      end

      def update(table, params, id)
        query("UPDATE #{table} SET
               #{params.map { |k, v| "#{k} = '#{v}'" }.join(', ')}
              WHERE id = '#{escape(id)}'")
      end

      def delete(table, id)
        query("DELETE FROM #{table} WHERE id = #{escape(id)}")
      end

      def load(rules, params)
        data = {}
        rules.each { |rule| (data[rule[:name]] = escape(params[rule[:name]])) unless rule.key?(:skip_load) }
        data
      end
    end
  end
end
