#!/bin/bash

printf "Enter Public API Key: "
read public_api_key
printf "Enter Private API Key: "
read private_api_key

keys_config="// Keys.xcconfig\n\nMARVEL_PUBLIC_API_KEY = \"$public_api_key\"\nMARVEL_PRIVATE_API_KEY = \"$private_api_key\""
echo "Keys.xcconfig file generated successfully!"
echo -e $keys_config > "Marvel Characters/config/Keys.xcconfig"


