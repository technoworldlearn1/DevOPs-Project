import csv
import redis
import boto3
from io import StringIO

# Configuration
redis_host = 'redis_host'
redis_port = 'redis_port'
redis_password = 'redis_password'
s3_bucket_name = 's3_bucket_name'
s3_file_name = 'redis_export.csv'

# Connect to Redis
r = redis.Redis(host=redis_host, port=redis_port, password=redis_password, decode_responses=True)

# Connect to S3
s3 = boto3.client('s3')

def export_redis_data_to_s3():
    # Fetch keys from Redis - this is a example
    keys = r.keys('*')
    
    # Create an in-memory file
    output = StringIO()
    writer = csv.writer(output)

    
    for key in keys:
        value = r.get(key)
        writer.writerow([key, value])

    output.seek(0)
    
    # Upload the file to S3
    s3.put_object(Bucket=s3_bucket_name, Key=s3_file_name, Body=output.getvalue())
    print(f"Data exported to S3 bucket '{s3_bucket_name}' with the file name '{s3_file_name}'.")

if __name__ == "__main__":
    export_redis_data_to_s3()
