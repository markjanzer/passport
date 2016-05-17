require_relative 'piranhaviewserver'

pvs = PiranhaViewServer.new

set :port, 3000
set :environment, :production

get '/' do
  p "Server is running"
end

post '/api/boats' do
  p params
  boat = pvs.new_boat(params[:boat][:capacity], params[:boat][:name])
  p boat.to_hash.to_json
  return boat.to_hash.to_json
end



