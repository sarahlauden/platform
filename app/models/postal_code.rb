require 'geo_distance'
require 'csv'

class PostalCode < ApplicationRecord
  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :latitude, presence: true, numericality: {greater_than: 17.5, less_than: 72.0}
  validates :longitude, presence: true, numericality: {greater_than: -160.0, less_than: -50.0}

  class << self
    def distance origin_zip, destination_zip
      origin = find_by code: origin_zip
      return nil if origin.nil?
      
      destination = find_by code: destination_zip
      return nil if destination.nil?
      
      GeoDistance.haversine(origin.coordinates, destination.coordinates)
    end
    
    def load_csv filename
      delete_all
      
      load_lines = Proc.new do |csv|
        now = Time.now
        previous_zips = {}

        bulk_insert(:code, :msa_code, :latitude, :longitude, :created_at, :updated_at, ignore: true) do |bulk|
          csv.each do |row|
            row['timestamp'] = now
            zip = row['ZIPCode']
            
            unless previous_zips.has_key?(zip)
              bulk.add ['ZIPCode', 'MSACode', 'Latitude', 'Longitude', 'timestamp', 'timestamp'].map{|f| row[f]}
              previous_zips[zip] = 1
            end
          end
        end
      end
      
      if filename =~ /^http:/
        CSV.open(open(filename), headers: true, &load_lines)
      elsif File.exists?(filename)
        CSV.open(filename, headers: true, &load_lines)
      else
        CSV.open($stdin, headers: true, &load_lines)
      end
      
      count
    end
  end
  
  def coordinates
    [lat, lon]
  end
  
  def coordinates= new_coordinates
    self.lat = new_coordinates[0]
    self.lon = new_coordinates[1]
  end
  
  def lat
    latitude
  end
  
  def lat= new_latitude
    self.latitude = new_latitude
  end
  
  def lon
    longitude
  end
  
  def lon= new_longitude
    self.longitude = new_longitude
  end
  
  def location
    return @location if defined?(@location)
    @location = Location.find_by(code: msa_code) || Location.find_by(code: state)
  end
end
