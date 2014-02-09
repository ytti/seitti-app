module ZipURL
class App < Seitti
  get '/' do
    slim :zip_post
  end

  get '/:id' do
    pass unless (entry = ZipURL[:url_id=>params[:id]])
    redirect entry.url
  end

  post '/' do
    id = get_id params[:url]
    entry = ZipURL[:url_id=>id] || ZipURL.new(:url_id=>id)
    entry.time = Time.now.utc
    entry.url  = params[:url]
    entry.save
    request.url + id
  end
end

module CFG
  DB = Seitti.db 'zip_url.db'
end

class ZipURL < Sequel::Model(CFG::DB)
  set_schema do
    primary_key :id
    String      :url_id, :unique=>true
    DateTime    :time
    blob        :url
  end
  create_table unless table_exists?
end
end
