#!/bin/bash
echo "Waiting 5 seconds..."
sleep 5
oc set route-backends hotel-booking-web-app hotel-booking-web-app=100 hotel-booking-web-app-v2=0 -n hotel-booking-web-app
echo "Done!"
