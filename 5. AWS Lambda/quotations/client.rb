require 'json'
require 'faraday'

URL = 'https://6ahosfl5la.execute-api.us-west-2.amazonaws.com/default/quotations'

connection = Faraday.new(url: URL)
response = connection.get do |request|
  request.params['id'] = 7
end

if response.success?
  puts response.status
  data = JSON.parse(response.body)
  puts data['id']
  puts data['author']
  puts data['excerpt']
end