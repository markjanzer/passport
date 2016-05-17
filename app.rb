require 'piranhaviewserver'

pvs = PiranhaViewServer.new

set :port, 3000
# set :environment, :production

post '/timeslots' do
  boat = pvs.new_boat(params[boat[capacity]], params[boat[name]])
  return boat.to_hash.to_json
end


