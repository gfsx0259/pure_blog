module Blog
  module Models
    autoload :Post, 'app/models/post'
    autoload :Author, 'app/models/author'
    autoload :Db, 'app/models/db'
    autoload :Validator, 'app/models/validator'
  end
end
