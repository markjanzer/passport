require_relative '../models/piranhaviewserver'

pvs = PiranhaViewServer.new

set :port, 3000
set :environment, :production

before do
  headers['Access-Control-Allow-Origin'] = "http://localhost:3333"
  headers["Content-Type"] = "application/json"
  puts headers
  puts "*" * 40
end

get '/' do
  p "Server is running"
end

post '/api/timeslots' do
  p params
  timeslot = pvs.new_timeslot(params[:timeslot][:start_time], params[:timeslot][:duration])
  p timeslot.to_hash.to_json
  return timeslot.to_hash.to_json
end

get '/api/timeslots' do
  p params
  timeslots_of_date = pvs.timeslots.select do |timeslot|
    timeslot.get_date_as_string == params[:date]
  end
  timeslots_as_hashes = pvs.get_collection_as_hashes(timeslots_of_date)
  p timeslots_as_hashes.to_json
  return timeslots_as_hashes.to_json
end

post '/api/boats' do
  p params
  boat = pvs.new_boat(params[:boat][:capacity], params[:boat][:name])
  p boat.to_hash.to_json
  return boat.to_hash.to_json
end

get '/api/boats' do
  p params
  p pvs.get_collection_as_hashes(pvs.boats).to_json
  return pvs.get_collection_as_hashes(pvs.boats).to_json
end

post '/api/assignments' do
  p params
  pvs.assign_boat_to_timeslot(params[:assignment][:timeslot_id], params[:assignment][:boat_id])
end

post '/api/bookings' do
  p params
  pvs.create_booking(params[:booking][:timeslot_id], params[:booking][:size])
end







