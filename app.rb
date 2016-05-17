require_relative 'piranhaviewserver'

pvs = PiranhaViewServer.new

set :port, 3000
set :environment, :production

get '/' do
  p "Server is running"
end

post '/api/timeslots' do
  timeslot = pvs.new_timeslot(params[:timeslot][:start_time], params[:timeslot][:duration])
  return timeslot.to_hash.to_json
end

get '/api/timeslots' do
  timeslots_of_date = pvs.timeslots.select do |timeslot|
    timeslot.get_date_as_string == params[:date]
  end
  timeslots_as_hashes = timeslots_of_date.map { |timeslot| timeslot.to_hash }
  return timeslots_as_hashes.to_json
end

post '/api/boats' do
  boat = pvs.new_boat(params[:boat][:capacity], params[:boat][:name])
  return boat.to_hash.to_json
end





