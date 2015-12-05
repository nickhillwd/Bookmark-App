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
get '/booomarks/:id' do
  sql = "SELECT * FROM tasks WHERE id = #{params[:id]}"
  @individual_bookmark = run_sql(sql)
  erb :show
end

# retrieve and edit a task from DB where id = :id
# persists the edited task to the DB where id = :id
# deleted task from DB where id = :id

def run_sql(sql)
  connect = PG.connect(dbname: 'bookmark', host: 'localhost')

  result = connect.exec(sql)

  connect.close

  result
end