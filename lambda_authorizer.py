import os
    
def lambda_handler(event, context):
    token = event.get('authorizationToken')

    if not token or token != os.environ.get("TOKEN"):
        return {
            "principalId": "user",
            "policyDocument": {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Action": "execute-api:Invoke",
                        "Effect": "Deny",
                        "Resource": event.get('methodArn')
                    }
                ]
            }
        }

    return {
        "principalId": "user",
        "policyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "execute-api:Invoke",
                    "Effect": "Allow",
                    "Resource": event.get('methodArn')
                }
            ]
        }
    }