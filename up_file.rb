require 'find'
module UpFile
class App < Seitti
  DIR = File.join(Seitti::ROOT, 'upfile')
  MAX_SIZE = 10*1024*1024*1024

  get '/' do
    @msg = 'drag file or click anywhere on the box'
    slim :up_file
  end

  post '/' do
    name      = params['file'][:filename]
    safe_name = safe_name name
    if dir_size(DIR) > MAX_SIZE
      @msg = 'unable, directory too large'
    else
      File.open File.join(DIR, safe_name), 'w' do |file|
        file.write(params['file'][:tempfile].read)
      end
      @msg = "#{name} uploaded succesfully"
      entry            = UpFile.new
      entry.name       = name
      entry.safe_name  = safe_name
      entry.ip         = request.ip
      entry.user_agent = request.user_agent
      entry.time       = Time.now.utc
      entry.save
    end
    slim :up_file
  end

  def dir_size dir
    size = 0
    Find.find(dir) { |f| size += File.size(f) if File.file?(f) }
    size
  end
  
  def safe_name name
    name = name.strip
    name.gsub!(/^.*(\\|\/)/, '')
    name.gsub!(/[^0-9A-Za-z.\-]/, '_')
    name
  end
end

module CFG
  DB = Seitti.db 'up_file.db'
end

class UpFile < Sequel::Model(CFG::DB)
  set_schema do
    primary_key :id
    String   :name
    String   :safe_name
    String   :ip
    String   :user_agent
    DateTime :time
  end
  create_table unless table_exists?
end
end
