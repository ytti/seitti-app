require 'base64'
class Seitti < Sinatra::Base
  ID_SIZE = 4
  DIR     = File.dirname(__FILE__)
  ROOT    = File.expand_path(File.join(DIR, '..'))

  #set :public_folder, File.join(ROOT, 'public')

  not_found do
    @image = e404
    slim :'404'
  end

  def get_id data, size=ID_SIZE
    #salt = SecureRandom.random_bytes # why salt it? same data == same id is fine?
    id = Digest::SHA2.digest(data)
    Base64.urlsafe_encode64(id)[0..size-1]
  end

  def e404 dir=settings.public_folder
    Dir.entries(File.join(dir, '404'))[2..-1].select{|e|e[0..0]!='.'}.shuffle.first
  end

  def self.db file
    file = File.join DIR, 'db', file
    Sequel::Model.plugin :schema
    Sequel.sqlite file
  end
end
