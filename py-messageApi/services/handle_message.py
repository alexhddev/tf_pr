import json

# prompt: aws lambda function to handle different http methods
def handler(event, context):
    method = event['httpMethod']
    
    if method == 'GET':
        return handle_get(event)
    elif method == 'POST':
        return handle_post(event)
    elif method == 'PUT':
        return handle_put(event)
    elif method == 'DELETE':
        return handle_delete(event)
    else:
        return {
            'statusCode': 405,
            'body': json.dumps('Method Not Allowed')
        }

def handle_get(event):
    # Handle GET request
    return {
        'statusCode': 200,
        'body': json.dumps('GET request handled')
    }

def handle_post(event):
    # Handle POST request
    return {
        'statusCode': 200,
        'body': json.dumps('POST request handled')
    }

def handle_put(event):
    # Handle PUT request
    return {
        'statusCode': 200,
        'body': json.dumps('PUT request handled')
    }

def handle_delete(event):
    # Handle DELETE request
    return {
        'statusCode': 200,
        'body': json.dumps('DELETE request handled')
    }