module Blog
  module Models
    class Author < Db
      TABLE_NAME = 'authors'.freeze

      RULES = [
        { name: :email, type: :email, required: true },
        { name: :username, required: true }
      ].freeze

      def get_list
        super(TABLE_NAME)
      end

      def get_by_id(id)
        super(TABLE_NAME, id)
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
