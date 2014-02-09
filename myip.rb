module MyIP
class App < Seitti
  get'/' do
    request.ip + "\n"
  end
end
end
