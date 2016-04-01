module Blog
  module Models
    class Tag < Db
      TABLE_NAME = 'tags'.freeze

      RULES = [
        { name: :body, required: true }
      ].freeze

      def get_list
        super(TABLE_NAME)
      end

      def get_by_ids(ids)
        query("SELECT * FROM #{TABLE_NAME} WHERE id IN(#{ids.join(',')})").first
      end

      def get_by_id(id)
        super(TABLE_NAME, id)
      end

      def add(params)
        super(TABLE_NAME, load(RULES, params))
      end

      def save(tag, post_id)
        tag_data = get_by_body(tag)
        tag_data ? tag_id = tag_data['id'].to_s : tag_id = add(body: tag)
        TagPost.new.add(tag_id: tag_id, post_id: post_id)
      end

      def get_by_body(body)
        query("SELECT id FROM #{TABLE_NAME} WHERE body = \"#{Db.new.escape(body)}\"").first
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
