import json
import logging
import os
import boto3

s3_client = boto3.client("s3")
BUCKET = os.environ["BUCKET"]

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def lambda_handler(event, context):
    # Log the received event
    logging.info(f"Received event: {json.dumps(event, indent=2)}.")

    # Get the bucket name and key of the uploaded file from the event and define the destination key
    BUCKET = event["Records"][0]["s3"]["bucket"]["name"]
    source_key = event["Records"][0]["s3"]["object"]["key"]
    destination_key = source_key.replace("source/", "destination/")
    try:
        # Copy the file to the new location
        copy_source = {"Bucket": BUCKET, "Key": source_key}
        s3_client.copy_object(CopySource=copy_source, Bucket=BUCKET, Key=destination_key)

        # Delete the original file
        s3_client.delete_object(Bucket=BUCKET, Key=source_key)
        logging.info(f"Successfully moved {source_key} to {destination_key}.")

    except Exception as e:
        logging.exception(f"Error moving file: {e}.")
