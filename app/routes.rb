module Blog
  module Routes
    autoload :Base, 'app/routes/base'
    autoload :Index, 'app/routes/index'
    autoload :Posts, 'app/routes/posts'
    autoload :Authors, 'app/routes/authors'
    autoload :Tags, 'app/routes/tags'
    autoload :Comments, 'app/routes/comments'
  end
end
