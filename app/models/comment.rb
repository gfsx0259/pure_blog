module Blog
  module Models
    class Comment < Db
      TABLE_NAME = 'comments'.freeze

      RULES = [
        { name: :content, required: true },
        { name: :author_id, required: true },
        { name: :post_id, required: true }
      ].freeze

      def get_list
        query("SELECT
               c.id,
               c.content,
               c.created_at,
               a.username,
               p.title
               FROM #{TABLE_NAME} c
               LEFT JOIN authors a
               ON c.author_id = a.id
               LEFT JOIN posts p
               ON c.post_id = p.id
               ORDER BY id DESC")
      end

      def get_by_post(post_id)
        query("SELECT
               c.content,
               c.author_id,
               c.post_id,
               c.created_at,
               a.username
               FROM #{TABLE_NAME} c
               LEFT JOIN authors a
               ON c.author_id = a.id
               WHERE post_id = '#{post_id}'
               ORDER BY c.id DESC")
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

      def delete_by_author(id)
        query("DELETE FROM #{TABLE_NAME} WHERE author_id = #{Db.new.escape(id)}")
      end
    end
  end
end
