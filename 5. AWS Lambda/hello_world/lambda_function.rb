require 'json'

def lambda_handler(event:, context:)
    { statusCode: 200,
      body: JSON.generate({
          message: 'Hello from Lambda!',
          code: 42,
          list: [4, 8, 15, 16, 23, 42],
          method: event['httpMethod'],
          path: event['path'],
          query: event['queryStringParameters'],
          memory: context.memory_limit_in_mb
      })
    }
end
