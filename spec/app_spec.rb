require 'spec_helper'
require_relative '../app'

# describe "API" do
#   describe 'POST timeslots' do
#     it 'creates a timeslot' do
#       post '/api/timeslots', :timeslot => { start_time: 1406052000, duration: 120 }
#       expect(last_response.status).to eq 200
#     end
#   end
# end


# I spent a while trying to get my RSpec to make API calls, first using airborne and then using RSpec.
# I decided to cut my losses and going for very basic model testing
describe 'PiranhaViewServer' do
  before :all do
    @pvs = PiranhaViewServer.new
  end

  describe 'boats' do
    before :all do
      @pvs.new_boat("4", "Atlantic Roamer")
    end

    it 'creates a boat' do
      expect(@pvs.boats.length).to eq 1
    end

    it 'creates a boat with an id of 0' do
      expect(@pvs.boats[0].id).to eq 0
    end

    it 'creates a boat with a capacity of 4' do
      expect(@pvs.boats[0].capacity).to eq 4
    end
  end

  describe 'timeslots' do
    before :all do
      @timeslot = @pvs.new_timeslot("1406052000", "120")
    end

    it 'creates a timeslot' do
      expect(@pvs.timeslots.length).to eq 1
    end

    it 'creates a timeslot with an id of 0' do
      expect(@timeslot.id).to eq 0
    end

    it 'creates a timeslot with no customers' do
      expect(@timeslot.customer_count).to eq 0
    end

    it 'creates a timeslot with no boats' do
      expect(@timeslot.boats.length).to eq 0
    end

    it 'can translate unix time to YYYY-MM-DD' do
      expect(@timeslot.get_date_as_string).to eq "2014-07-22"
    end
  end

  describe 'assignments' do
    before :all do
      @timeslot = @pvs.new_timeslot("1406052000", "120")
      @boat = @pvs.new_boat("4", "Atlantic Roamer")
      @pvs.assign_boat_to_timeslot("1", "1")
    end

    it 'adds a boat to the timeslot' do
      expect(@timeslot.boats.length).to eq 1
    end

    it 'increases availability by the space on the boat' do
      expect(@timeslot.availability).to eq @boat.capacity
    end
  end

  describe 'bookings' do
    before :all do
      @timeslot = @pvs.new_timeslot("1406052000", "120")
      @boat = @pvs.new_boat("4", "Atlantic Roamer")
      @pvs.assign_boat_to_timeslot("2", "2")
      @pvs.create_booking("2", "1")
    end

    it 'reduces the timeslots capactity by one' do
      expect(@timeslot.availability).to eq 3
    end
  end

end

