#!/bin/bash

# Extract the tag from command-line arguments
tag=$1

# Check if the tag is valid
if [[ "$tag" =~ ^[a-zA-Z0-9-]+$ ]]; then
    # Run the curl command and open the first valid preview link
    command="curl -s -X GET 'https://api.waifu.im/search?included_tags=$tag&height=%3E=2000'"

    # Print the command for debugging
    echo "Command: $command"

    # Run the command and print the entire API response for debugging
    api_response=$(eval "$command")
    echo "API Response: $api_response"

    # Extract the preview link using jq
    image_links=$(echo "$api_response" | jq -r '.images[0].preview_url')

    # Print the output for debugging
    echo "Image Links: $image_links"

    # Check if the preview link is non-empty and contains "https://www.waifu.im/preview/"
    if [ -n "$image_links" ] && [[ $image_links != "null" ]]; then
        # Open the valid image link in a web browser
        xdg-open "$image_links"
    else
        # If no valid preview link is found or the response is empty
        echo "Error: Unable to retrieve a valid image link from waifu.im. Check if the tag is correct or try another tag."
    fi
else
    # If the tag is not valid
    echo "Error: Tags must consist of alphanumeric characters or hyphens only."
fi
