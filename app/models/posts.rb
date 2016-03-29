module Blog
  module Models
    class Posts < Db

      TABLE_NAME = 'posts'

      RULES = [
          { :name => :title, :required => true },
          { :name => :content, :required => true },
          { :name => :author_id, :required => true }
      ]

      def add(params)
        super(TABLE_NAME, load(RULES, params))
      end

    end
  end
end
