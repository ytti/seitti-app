module Paste
class App < Seitti
  get '/' do
    slim :post
  end

  get '/:id.?:format?' do
    pass unless (entry = Paste[:paste_id=>params[:id]])
    @paste = entry.paste
    txt ? @paste : slim(:get)
  end

  post '/' do
    id = get_id params[:paste]
    entry = Paste[:paste_id=>id] || Paste.new(:paste_id=>id)
    entry.time  = Time.now.utc
    entry.paste = params[:paste]
    entry.save
    request.url + id
  end

  def txt
    text = true if params[:format] == 'txt' 
    text = true if [ /^curl/i, /^wget/i, /^fetch/i ].any? { |re| request.user_agent.match re }
    content_type :text if text
    text
  end
end

module CFG
  DB = Seitti.db 'paste.db'
end

class Paste < Sequel::Model(CFG::DB)
  set_schema do
    primary_key :id
    String      :paste_id, :unique=>true
    DateTime    :time
    blob        :paste
  end
  create_table unless table_exists?
end
end
