puts "Destroy existing data"
puts "It could take a while"
PotatoPrice.destroy_all
puts "Data successfully destroyed"
puts "---"
puts "Create new data"
puts "It could take a while to create 1 day data"
3600.times do |i|
  PotatoPrice.create(
    time: DateTime.now.beginning_of_day + i.seconds,
    value: rand(100.25..100.29).round(2)
  )
end
puts "Data successfully created"
