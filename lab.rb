module Lab
class App < Seitti
  require 'json'
  require 'pp'
  get'/' do
    content_type :text
  end
  get '/req.?:format?' do
    params[:format]
  end
  post '/commit' do
    content_type :json
    #k = JSON.load params['commits']
    k = JSON.load request.body.read
    pp k
    200
  end
  get '/env' do
    out = ''
    ENV.each do |k,v|
      out += "%30s => %s\n" % [k, v]
    end
    content_type :text
    out
  end
  get '/tst' do
    out = ''
    out << "params\n"
    params.each do |k,v|
      out += "%s30 => %s\n" % [k, v]
    end
    content_type :text
    out << "request\n"
    out << request.url + "\n"
    request.methods.each do |met|
      out << met.to_s + "\n"
    end
    #request.each do |k,v|
    #  out += "%s30 => %s" % [k, v]
    #end
    out
  end
end
end
