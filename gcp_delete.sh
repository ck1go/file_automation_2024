#!/bin/bash

# Define your bucket name
BUCKET_NAME="your_bucket_name"

# Calculate the date 2 years ago
TWO_YEARS_AGO=$(date -d "2 years ago" +"%Y-%m-%dT%H:%M:%SZ")

# List objects in the bucket and filter by the last modified time
OBJECTS=$(gsutil ls -l gs://$BUCKET_NAME | grep -E "^-" | awk '{print $1,$2,$3,$4,$5,$6}')

# Loop through each object and check if it's older than 2 years
while read -r OBJECT; do
    MODIFIED_DATE=$(echo $OBJECT | awk '{print $1,$2}')
    if [[ "$MODIFIED_DATE" < "$TWO_YEARS_AGO" ]]; then
        # Object is older than 2 years, take appropriate action
        OBJECT_NAME=$(echo $OBJECT | awk '{print $NF}')
        echo "Object $OBJECT_NAME is older than 2 years"
        # You can delete the object or perform any other action here
    fi
done <<< "$OBJECTS"