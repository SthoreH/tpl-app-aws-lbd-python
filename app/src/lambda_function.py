import json
import logging

# Initialize the logger
logger = logging.getLogger()
logger.setLevel("INFO")

def lambda_handler(event, context):
    """
    Main Lambda handler function
    Parameters:
        event: Dict containing the Lambda function event data
        context: Lambda runtime context
    Returns:
        Dict containing status message
    """
    logger.info(f"Successfully received event: {json.dumps(event)}")
    return{
        "statusCode": 200,
        "body": json.dumps(event)
    }