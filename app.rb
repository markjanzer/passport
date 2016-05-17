require_relative 'piranhaviewserver'

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
  p "POST TIMESLOTS"
  p params
  timeslot = pvs.new_timeslot(params[:timeslot][:start_time], params[:timeslot][:duration])
  p timeslot.to_hash.to_json
  return timeslot.to_hash.to_json
end

get '/api/timeslots' do
  p "GET TIMESLOTS"
  if pvs.timeslots.empty?
    return [].to_json
  else
    p pvs.timeslots[0].get_date_as_string == params[:date]
    timeslots_of_date = pvs.timeslots.select do |timeslot|
      timeslot.get_date_as_string == params[:date]
    end
    p timeslots_of_date
    timeslots_as_hashes = pvs.get_collection_as_hashes(timeslots_of_date)
    p timeslots_as_hashes.to_json
    return timeslots_as_hashes.to_json
  end
end

post '/api/boats' do
  p "POST BOATS"
  p params
  boat = pvs.new_boat(params[:boat][:capacity], params[:boat][:name])
  p boat.to_hash.to_json
  p pvs.boats
  return boat.to_hash.to_json
end

get '/api/boats' do
  p "GET BOATS"
  p params
  p pvs.get_collection_as_hashes(pvs.boats).to_json
  return pvs.get_collection_as_hashes(pvs.boats).to_json
end





