=begin

Tests for the AWS Console:

-----------------------------------------------------------
GET

{
  "httpMethod": "GET"
}
-----------------------------------------------------------

-----------------------------------------------------------
POST

{
  "httpMethod": "POST",
  "body": "{ \"Author\": \"Michael Crithton\", \"Title\": \"Jurassic Park\", \"Year\": 1990}"
}
-----------------------------------------------------------

=end

require 'json'
require 'aws-sdk-dynamodb'

DYNAMODB = Aws::DynamoDB::Client.new
TABLE_NAME = 'Books'

#-------------------------------------------------------------------
class HttpStatus
  OK = 200
  CREATED = 201
  BAD_REQUEST = 400
end

#--------------------------------------------------------------------
def make_response(status, body)
  {
    statusCode: status,
    body: JSON.generate(body)
  }
end

#--------------------------------------------------------------------
def handle_bad_method(method)
  make_response(405, {message: "Method not supported: #{method}"})
end

#--------------------------------------------------------------------
def make_result_list(items)
  items.map do |item| {
      'Author' => item['Author'],
      'Title' => item['Title'],
      'Year' => item['Year'].to_i,
      'Note' => item['Note']
    }
  end
end

#--------------------------------------------------------------------
def sort_items(items)
  items.sort! {|a, b| a['Year'] <=> b['Year']}
  items.sort! {|a, b| a['Author'] <=> b['Author']}
end

#--------------------------------------------------------------------
def get_books
  items = DYNAMODB.scan(table_name: TABLE_NAME).items
  sort_items(items)
  make_result_list(items)
end

#--------------------------------------------------------------------
def handle_get
  make_response(HttpStatus::OK, get_books)
end

#--------------------------------------------------------------------
def parse_body(body)
  if body
    begin
      data = JSON.parse(body)
      data.key?('Author') and data.key?('Title') ? data : nil
    rescue JSON::ParserError
      nil
    end
  else
    nil
  end
end

#--------------------------------------------------------------------
def store_book_item(body)
  data = parse_body(body)
  if data
    DYNAMODB.put_item({
      table_name: TABLE_NAME,
      item: data
    })
    true
  else
    false
  end
end

#--------------------------------------------------------------------
def handle_post
  make_response(HttpStatus::CREATED, {message: 'Resource created or updated'})
end

#--------------------------------------------------------------------
def handle_bad_request
  make_response(HttpStatus::BAD_REQUEST, {message: 'Bad request (invalid input)'})
end

#--------------------------------------------------------------------
def lambda_handler(event:, context:)
  method = event['httpMethod']
  case method

  when 'GET'
    handle_get

  when 'POST'
    if store_book_item(event['body'])
      handle_post
    else
      handle_bad_request
    end

  else
    handle_bad_method(method)
  end
end
