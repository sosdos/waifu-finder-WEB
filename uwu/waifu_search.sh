#!/bin/bash

# Extract the tag from command-line arguments
tag=$1

# Check if the tag is valid
if [[ "$tag" =~ ^[a-zA-Z0-9-]+$ ]]; then
    # Run the curl command and print the entire API response for debugging
    api_response=$(curl -s -X GET "https://api.waifu.im/search?included_tags=$tag&height=>=2000")
    echo "API Response: $api_response"

    # Print the relevant information for debugging
#    echo "Images Array: $(echo "$api_response" | jq -r '.images')"

    # Extract the image link using jq
    image_link=$(echo "$api_response" | jq -r '.images[0].url')

    # Extract the file extension from the image link
#    file_extension=$(echo "$image_link" | awk -F'.' '{print tolower($NF)}')

    # Print the output for debugging
#    echo "Image Link: $image_link"
#    echo "File Extension: $file_extension"

    # Check if the image link is non-empty and contains "https://cdn.waifu.im/"
    if [ -n "$image_link" ] && [[ $image_link != "null" ]]; then

	xdg-open $image_link

        # Print the valid image link
        echo "Image Link: $image_link"
    else
        # If no valid image link is found or the response is empty
        echo "Error: Unable to retrieve a valid image link from waifu.im. Check if the tag is correct or try another tag."
    fi
else
    # If the tag is not valid
    echo "Error: Tag must consist of alphanumeric characters or hyphens only."
fi
