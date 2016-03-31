module Blog
  module Models
    class TagPost < Db
      TABLE_NAME = 'tags_posts'.freeze

      RULES = [
        { name: :tag_id, required: true },
        { name: :post_id, required: true }
      ].freeze

      def get_ids_by_post(post_id)
        ids = query("SELECT tag_id FROM #{TABLE_NAME} WHERE post_id = #{post_id}")
        ids.to_a.map { |hash| hash['tag_id'] } if ids
      end

      def remove_by_post(post_id)
        query("DELETE FROM #{TABLE_NAME} WHERE post_id = #{post_id}")
      end

      def add(params)
        super(TABLE_NAME, load(RULES, params))
      end
    end
  end
end
