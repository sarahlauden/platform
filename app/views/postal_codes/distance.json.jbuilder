json.distance @distance

json.from do
  json.code @from.code

  json.city @from.city
  json.state @from.state

  json.latitude @from.latitude
  json.longitude @from.longitude
end

json.to do
  json.code @to.code

  json.city @to.city
  json.state @to.state

  json.latitude @to.latitude
  json.longitude @to.longitude
end

json.messages ['Distance is measured in miles.']