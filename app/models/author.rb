module Blog
  module Models
    class Author < Db
      TABLE_NAME = 'authors'.freeze

      RULES = [
        { name: :username, required: true }
      ].freeze

      def get_list
        super(TABLE_NAME)
      end

      def get_by_id(id)
        super(TABLE_NAME, id)
      end

      def get_by_username(username)
        result = query("SELECT id FROM #{TABLE_NAME} WHERE username = '#{Db.new.escape(username)}'").first
        result['id'].to_s if result && result.key?('id')
      end

      def add(params)
        super(TABLE_NAME, load(RULES, params))
      end

      def update(params)
        super(TABLE_NAME, load(RULES, params), params[:id])
      end

      def delete(id)
        super(TABLE_NAME, id)
      end
    end
  end
end
