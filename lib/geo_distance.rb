module GeoDistance
  class << self
    def haversine origin, destination
      radius = 3959
      
      origin_lat = radians(origin[0])
      destination_lat = radians(destination[0])
      
      delta_lat = radians(destination[0] - origin[0])
      delta_lon = radians(destination[1] - origin[1])
      
      a = (
        (Math.sin(delta_lat / 2) ** 2) + (
          Math.cos(origin_lat) * Math.cos(destination_lat) * 
          (Math.sin(delta_lon / 2) ** 2)
        )
      )
      
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      
      radius * c
    end
    
    def radians degrees
      degrees * Math::PI / 180.0
    end
  end
end