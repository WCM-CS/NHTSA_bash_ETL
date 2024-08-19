#!/bin/bash


# Download the passenger vehicle data
wget https://crashstats.nhtsa.dot.gov/Api/Public/ViewPublication/813592
echo "Downloaded passenger data"

# Download the large truck data
wget https://crashstats.nhtsa.dot.gov/Api/Public/ViewPublication/813588
echo "Downloaded large truck data"

# Download the motrocycle data
wget https://crashstats.nhtsa.dot.gov/Api/Public/ViewPublication/813589
echo "Download motorcycle data"