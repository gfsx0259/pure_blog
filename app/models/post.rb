module Blog
  module Models
    class Post < Db

      TABLE_NAME = 'posts'

      RULES = [
          { :name => :title, :required => true },
          { :name => :content, :required => true },
          { :name => :author_id, :required => true }
      ]

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
