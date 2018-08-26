require "pry"
require "pry-byebug"
require_relative "ignored"
require_relative "normalize"

# https://angel.co/jobs#find/f!%7B%22roles%22%3A%5B%22Software%20Engineer%22%2C%22Data%20Scientist%22%5D%2C%22locations%22%3A%5B%221688-United%20States%22%5D%7D
# Run the below query in the console
# $('.tags').each(function( index ) {
  # console.log( index + ": " + $( this ).text() );
# });
# Copy results to new file in data
# Clean up to be of similar format to those already there.

technologies = Hash.new(0)
File.open("./data/angel_list_us_tags.txt", "r").each_line do |line|
  tokens = line.split(' · ')
  tokens.each do |token|
    token = token.strip.downcase
    next if IGNORE.include?(token)
    next if FUZZY_IGNORE.map { |regex| token.match regex }.reject { |e| e.nil? }.count.positive?
    token = NORMALIZE.select { |k, v| v.include?(token) }.first&.first || token
    technologies[token] += 1
  end
end

pp technologies.sort_by { |key, value| [-value.to_i, key] }
