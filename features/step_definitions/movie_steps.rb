# Add a declarative step here for populating the DB with movies.


Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
#flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}/m
  page.body.should =~ regexp
end

Then /I should see movies sorted by (title|release date)/ do |e|
  e.gsub! ' ', '_'
  titles = page.all('tbody#movielist td.Title')
#Movie.all(:order => e).each_slice(2) do |movies|
  titles.each_slice(2) do |title|
    assert title[0].text < title[1].text if title.size > 1
#page.body.should =~ /#{movies[0].title}.*#{movies[1].title}/m if movies.size > 1
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /^I (un)?check the following ratings: (.+)$/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  un='un' if uncheck
  to_check = []
  rating_list.split(/,\s*/).each do |rating|
    steps %Q{When I #{un}check "ratings[#{rating}]"}
  end
end

Then /^(?:|I )should see (all|none) of the movies(?: sorted by )?(title|release date)?$/ do |m,e|
  rows = page.all('tbody#movielist tr')
  if m == 'all'
    assert rows.count == Movie.count
    e.gsub! ' ', '_' if e # turn release date => release_date
    # Check that all the movies are displayed in order
    Movie.all(:order => e).each_slice(2) do |movies|
      page.body.should =~ /#{movies[0].title}.*#{movies[1].title}/m if movies.size > 1
    end
  else
    assert rows.count == 0
  end
end
