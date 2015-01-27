module Lab
class App < Seitti
  set connections: []
  require 'json'
  require 'pp'

  Thread.new do
    loop do
      settings.connections.each { |conn| conn << "poop\n\n" }
      sleep 1
    end
  end

  get '/virta', provides: 'text/event-stream' do
    response.headers['X-Accel-Buffering'] = 'no'
    stream :keep_open do |conn|
      settings.connections << conn
      sleep 10
      conn.callback { settings.connections.delete conn }
    end
  end

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
