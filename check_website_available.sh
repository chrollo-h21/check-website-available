#!/bin/bash

# Author: chrollo_h21
# Script check website available when status response 200
# curl must be required in system

# define current time_stamp and log path
time_stamp=$(timedatectl show --property=TimeUSec --value)

# location to save log
log_path="./website_available.log"

# telegram alert
api_key="your_api_key"
chat_id="your_chatid"

# List website
websites=(
    "https://website-A.com"
    "https://website-B.com"
    "https://website-C.com"
)

for url in "${websites[@]}"; do
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")

    if [[ "$response" -ge 200 && "$response" -lt 399 ]]; then
        message="$time_stamp - $url available - status:$response"
        echo "$message" >>"$log_path"
    else
        tele_api="https://api.telegram.org/bot$api_key/sendMessage"
        message="$time_stamp - $url unavailable - status:$response"
        echo "$message" >>"$log_path"
        #Send alert to Telegram if unvailable
        curl -s -o /dev/null -X POST -d "chat_id=$chat_id" -d "text=$message" -d "parse_mode=html" "$tele_api"
    fi
done
