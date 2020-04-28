require 'json'
require 'yaml'

QUOTATIONS = YAML.load_file('quotations.yaml')

def make_url(host, path, index)
  "https://#{host}/default#{path}?id=#{index}"
end

def process_output(event)
  path = event['path']
  headers = event['headers']
  host = headers['Host']
  result = []
  QUOTATIONS.each_with_index do |quotation, index|
    result << {
      id: index,
      author: quotation['author'],
      url: make_url(host, path, index)
    }
  end
  result
end

def process_one_quotation(id)
  {
    id: id,
    author: QUOTATIONS[id]['author'],
    excerpt: QUOTATIONS[id]['excerpt'],
  }
end

def lambda_handler(event:, context:)
  method = event['httpMethod']
  if method == 'GET'
    query_string = event['queryStringParameters'] || {}
    if query_string['id']
      id = query_string['id'].to_i
      if 0 <= id and id < QUOTATIONS.size
        { statusCode: 200,
          body: JSON.pretty_generate(process_one_quotation(id))
        }
      else
        { statusCode: 404,
          body: JSON.generate({
            error: "ID #{id} not found"
          })
        }
      end
    else
      { statusCode: 200,
        body: JSON.pretty_generate(process_output(event))
      }
    end
  else
    { statusCode: 405,
      body: JSON.generate({
        error: "Method not allowed: #{method}"
      })
    }
  end
end
