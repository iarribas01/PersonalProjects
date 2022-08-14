# # given a file

# File.open("Exercises.txt") do |file|

# end

# # create a program that returns the exercise number and subcategory


exercises = {
  "Document Again" => 9,
  "Easy 1" => 10,
  "Easy 2" => 10,
  "Easy 3" => 10,
  "Easy 4" => 10,
  "Easy 5" => 11,
  "Easy 6" => 10,
  "Easy 7" => 10,
  "Easy 8" => 10,
  "Easy 9" => 11,
  "Medium 1" => 10,
  "Medium 2" => 10,
  "Advanced 1" => 9,
  "Debugging" => 11
}

category = exercises.keys.sample
problem_num = rand(1..exercises[category])

puts "#{category} ##{problem_num}"