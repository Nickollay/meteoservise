#Take data from XML of meteoservice.ru
#https://www.meteoservice.ru/content/export

#Library which's used to build HTTP user-agents.
require 'net/http'
#URI is a module providing classes to handle Uniform Resource Identifiers.
require 'uri'
#Represents a full XML document, including PIs (processing instructions), a doctype, etc. 
require 'rexml/document'

# Create HashArray where keys are posible varaety of attribute's 'cloudiness' value in xml
#Assign HashArray to constant.
CLOUDINESS = {-1 => "Fog", 0 => "Sunny", 1 => "Partly Cloudy", 2 => "Mostly Cloudy", 3  => "Showers"}

# => #<URI::HTTP https://xml.meteoservice.ru/export/gismeteo/point/1891.xml>
# Url with xml of Sevastopol weather
uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/1891.xml")

#Send request and save response in var "responce"
response = Net::HTTP.get_response(uri)

#Save xml in 'doc'
doc = REXML::Document.new(response.body)

#Take value of city name from atribute 'sname' of element 'TOWN' of element 'REPORT' of xml
#Decoding it from HEX to UTF-8 & save to 'city_name'
city_name = URI.unescape(doc.root.elements['REPORT/TOWN'].attributes['sname'])

#Take all child elements from element 'TOWN', which child of element 'REPORT' of xml document
#Put them to array and take current forecast with '.elements.to_a[0]'  
current_forecast = doc.root.elements['REPORT/TOWN'].elements.to_a[0]

#Take min temperature from attribute 'min' of element "TEMPERATURE"
#Save it to var 'min_temp'
min_temp = current_forecast.elements['TEMPERATURE'].attributes['min']

#Make the same with max temperature & max wind
max_temp = current_forecast.elements['TEMPERATURE'].attributes['max']
max_wind = current_forecast.elements['WIND'].attributes['max']

#Take value of cloudiness from it's attribute 'cloudiness' from element 'PHENOMENA'
#Then convert value to integer
clouds_index = current_forecast.elements['PHENOMENA'].attributes['cloudiness'].to_i

#Assign value from HashArray 'CLOUDINESS' of key from clod_index to var clouds 
clouds = CLOUDINESS[clouds_index]

#Output name of city
puts city_name

#Output min & max temperrature celcium  
puts "Temperture: from #{min_temp}C to #{max_temp}C"

#Output speed of wind in m/s
puts "Wind: to #{max_wind} m/s"

#Output cloudiness
puts clouds


