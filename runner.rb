require 'sinatra'
require 'sinatra/contrib/all' if development?
require 'pg'
require 'pry-byebug'

#get all tasks from DB
get '/bookmarks' do
  sql = "SELECT * FROM bookmarks"
  @bookmarks = run_sql(sql)
  erb :index
end

#render a from
get '/bookmarks/new' do
  erb :new
end

# persists new task to DB
post '/bookmarks' do
  name = params[:name]
  genre = params[:genre]
  info = params[:info]
  sql = "INSERT INTO bookmarks (name, genre, info) VALUES ('#{name}', '#{genre}', '#{info}')"
  run_sql(sql)
  redirect to('/bookmarks')
end

# get individual task from DB where id = :id
get '/bookmarks/:id' do
  sql = "SELECT * FROM bookmarks WHERE id = #{params[:id]}"
  @individual_bookmark = run_sql(sql)
  erb :show
end

# retrieve and edit a task from DB where id = :id
get '/bookmarks/:id/edit' do
  sql = "SELECT * FROM bookmarks WHERE id = #{params[:id]}"
  @edit_bookmark = run_sql(sql).first
  erb :edit
end

# persists the edited task to the DB where id = :id
post '/bookmarks/:id' do
  new_name = params[:name]
  new_genre = params[:genre]
  new_info = params[:info]
  edit_id = params[:id]
  sql = "UPDATE bookmarks SET name = '#{new_name}', genre = '#{new_genre}', info = '#{new_info}'  WHERE id = #{edit_id}"

  run_sql(sql)
  redirect to("/bookmarks/#{params[:id]}")
end

# deleted task from DB where id = :id
post '/bookmarks/:id/delete' do
  sql = "DELETE FROM bookmarks WHERE id = #{params[:id]}"
  run_sql(sql)
  redirect to('/bookmarks')
end

#search for keywork from DB
get '/bookmarks/search' do
  redirect to('/bookmarks')
end

def run_sql(sql)
  connect = PG.connect(dbname: 'bookmark', host: 'localhost')

  result = connect.exec(sql)

  connect.close

  result
end