require 'artoo'

# connection :crazyflie, :adaptor => :crazyflie, :supports_hover => true
# device :drone, :driver => :crazyflie, :connection => :crazyflie, :interval => 0.1

connection :pebble, :adaptor => :pebble, :port => '127.0.0.1:4567', :id => "378B"
device :watch, :driver => :pebble, :connection => :pebble

work do
  on watch, :media_control => :button_push

  display_watch
end

def button_push(caller, data)
  return if data.nil?

  case data.button
  when :previous
    drone.take_off

  when :next
    drone.land
    drone.stop

  when :playpause
    if @hovering
      @hovering = false
      drone.hover(:stop)
      drone.land
      drone.stop
    else
      @hovering = true
      drone.hover(:start)
    end
    
  else
    puts "WAT"
  end
end

def display_watch
  watch.set_nowplaying_metadata("Takeoff", "Landing", "Hover")
end
