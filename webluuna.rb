module Webluuna
class App < Seitti
  RootDir = '/home/ytti/public_html/cfg'

  get '/get/:type/:file' do
    file = params[:file]
    type = params[:type]

    content_type :text
    Sapluuna.new(root_directory: RootDir).parse File.read(File.join(RootDir, type, file))
  end

  get '/submit' do
    vars = params.dup
    labels = get_hostname_labels(params[:hostname].to_s)
    file = vars.delete 'file'
    cfg = { labels: labels, variables: vars, root_directory: RootDir }
    content_type :text
    file = File.join RootDir, 'dev', file
    Sapluuna.new(cfg).parse File.read(file)
  end

  get '/ui/' do
    @devices = devices
    haml :webluuna
  end

  get '/vars' do
    labels = get_labels params[:input] if params[:input]
    cfg = { labels: labels, root_directory: RootDir }
    content_type :json
    k = JSON.generate vars(params[:file], cfg)
    pp k
    k
  end

  def get_labels input
    get_hostname_labels input['hostname'].to_s
  end

  def get_hostname_labels hostname
    role = %w( er sr tr ).find { |type| re=/\d-#{type}\d/; hostname.match re }
    type = role ? 'router' : 'switch'
    [role, type].flatten.compact
  end

  def vars file, cfg
    cfg.delete :variables
    cfg[:discover_variables] = true
    file = File.join(RootDir, 'dev', file)
    sap = Sapluuna.new(cfg)
    sap.parse File.read(file)
    sap.discovered_variables
  end

  def devices
    devs = {}
    dir = File.join RootDir, 'dev'
    Dir.foreach(dir).each do |f|
      next unless File.file? File.join(dir, f)
      devs[f.upcase.gsub(/_/, ' ')] = f
    end
    devs
  end

end
end
