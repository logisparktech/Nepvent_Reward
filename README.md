# nepvent_reward

This Project is called Nepvent Reward.

## Getting Started

## clean

run `flutter pub cache clean`

## Create a .env file and insert the following contents

# Test/Demo Environment
PACKAGE_NAME=com.logisparktech.nepvent_reward
API_URL=http://162.0.216.97:8000/
SOCKET_API_URL=http://162.0.216.97:4000/notification

## Production Environment
# PACKAGE_NAME=com.logisparktech.nepvent_reward
# API_URL=https://rms.nepvent.com/api/api/
# SOCKET_API_URL=https://rms.nepvent.com/api/notification

## Active rename

run `flutter pub global activate rename`

## change name of app
### Demo APP_NAME - nepvent_reward
### Prod APP_NAME- Nepvent Reward
run `rename setAppName --targets ios,android --value "APP_NAME"`
