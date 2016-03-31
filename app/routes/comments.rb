module Blog
  module Routes
    class Comments < Base
      before { @comment = Comment.new }

      validation_required :POST, '/comments/add', params: Comment::RULES
      validation_required :POST, '/comments/add_guest', params: Comment::RULES
      validation_required :POST, '/comments/update/:id', params: Comment::RULES

      get '/comments' do
        display :index, locals: { comments: @comment.get_list }
      end

      get '/comments/add' do
        display :form, locals: { authors: Author.new.get_list, posts: Post.new.get_list }
      end

      post '/comments/add' do
        if errors
          session['errors'] = errors
          redirect '/comments/add'
        end

        @comment.add(params)
        redirect '/comments'
      end

      # author_id contains author (for common validation)
      post '/comments/add_guest' do
        if errors
          session['errors'] = errors
        else
          @author = Author.new
          # trying to get existing
          author_id = @author.get_by_username(params['author_id'])
          # add new if it's new
          author_id = @author.add(username: params['author_id']) unless author_id
          params['author_id'] = author_id
          @comment.add(params)
        end
        redirect "/posts/view/#{params['post_id']}"
      end

      get '/comments/update/:id' do
        display :form, locals: { comment: @comment.get_by_id(params[:id]), authors: Author.new.get_list, posts: Post.new.get_list }
      end

      post '/comments/update/:id' do
        if errors
          session['errors'] = errors
          redirect "/comments/update/#{params['id']}"
        end
        @comment.update(params)
        redirect '/comments'
      end

      get '/comments/delete/:id' do
        @comment.delete(params[:id])
        redirect '/comments'
      end

      get '/comments/view/:id' do
        display :view, locals: { comment: @comment.get_by_id(params[:id]) }
      end
    end
  end
end
