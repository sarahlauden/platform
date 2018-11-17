json.postal_code do
  json.code @postal_code.code

  json.city @postal_code.city
  json.state @postal_code.state

  json.latitude @postal_code.latitude
  json.longitude @postal_code.longitude
end