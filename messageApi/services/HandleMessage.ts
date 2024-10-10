import { S3Client } from "@aws-sdk/client-s3";
import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { Context } from "vm";


const s3Client = new S3Client()

async function handler(event: APIGatewayProxyEvent, context: Context): Promise<APIGatewayProxyResult> {

    return {} as any
    
}