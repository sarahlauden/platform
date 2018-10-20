json.majors do
  @majors.each do |major|
    json.set! major.name, major.children.map(&:name)
  end
end
