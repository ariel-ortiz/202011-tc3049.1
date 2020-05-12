require 'aws-sdk-dynamodb'

dynamodb = Aws::DynamoDB::Client.new

thing = {
  'Author' => 'Suzanne Collins',
  'Title' => 'Catching Fire',
  'Year' => 2009,
  'Note' => nil
}

dynamodb.put_item(table_name: 'Books', item: thing)

puts 'Item has been put'
