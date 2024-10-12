import json
import os
from boto3 import resource
import requests

s3_client = resource('s3')
bucket_name = os.environ['MESSAGES_BUCKET']

def handler(event, context):
    
    # print the requests version:
    print(requests.__version__)

    try:
        method = event['httpMethod']
        
        if method == 'GET':
            return handle_get(event)
        elif method == 'POST':
            return handle_post(event)
        else:
            return {
                'statusCode': 405,
                'body': json.dumps('Method Not Allowed')
            }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(str(e))
        }
    



def handle_get(event):
    
    # list all objects in the bucket
    bucket = s3_client.Bucket(bucket_name)
    objects = bucket.objects.all()

    return {
        'statusCode': 200,
        'body': json.dumps(objects)
    }
    
def handle_post(event):
    
    if 'body' in event:
        body = json.loads(event['body'])
        # put the body in the bucket
        bucket = s3_client.Bucket(bucket_name)
        bucket.put_object(Key='message.txt', Body=body['message'])
        return {
            'statusCode': 200,
            'body': json.dumps('POST request handled')
        }        

    return {
        'statusCode': 400,
        'body': json.dumps('Request body is missing')
    }
