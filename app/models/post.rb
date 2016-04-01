module Blog
  module Models
    class Post < Db
      TABLE_NAME = 'posts'.freeze

      RULES = [
        { name: :title, required: true },
        { name: :content, required: true },
        { name: :author_id, required: true },
        { name: :tags, required: false, skip_load: true }
      ].freeze

      def get_list
        query("SELECT
               p.id,
               p.title,
               p.content,
               p.created_at,
               a.username
               FROM #{TABLE_NAME} p
               LEFT JOIN authors a
               ON p.author_id = a.id
               ORDER BY id DESC")
      end

      def get_by_id(id)
        super(TABLE_NAME, id)
      end

      def add(params)
        post_id = super(TABLE_NAME, load(RULES, params))
        params['tags'].split(',').each { |tag| Tag.new.save(tag.strip, post_id) }
      end

      def update(params)
        post_id = params[:id]
        @tag = Tag.new
        super(TABLE_NAME, load(RULES, params), post_id)
        if params['tags']
          TagPost.new.remove_by_post(post_id)
          params['tags'].each do |tag_id|
            @tag.save(@tag.get_by_id(tag_id)['body'], post_id)
          end
        end
      end

      def delete(id)
        super(TABLE_NAME, id)
      end
    end
  end
end
