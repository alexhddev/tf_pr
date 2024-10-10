import { S3Client } from "@aws-sdk/client-s3";
import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { Context } from "vm";


const s3Client = new S3Client()
const messagesBucket = process.env.MESSAGES_BUCKET

async function handler(event: APIGatewayProxyEvent, context: Context): Promise<APIGatewayProxyResult> {

    console.log(messagesBucket);

    return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Hello World' })
    }    
}

export { handler }