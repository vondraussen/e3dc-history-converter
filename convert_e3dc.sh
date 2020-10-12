#!/bin/bash

timestamp=$(date +%s%N)

file=$1
if [[ ! -a $file ]]; then
  echo "provide a file to convert!"
  exit 1
fi

# add a new line to the end of the file... it is missing
sed -i -e '$a\' $file

# replace ; with ,
sed -i 's/;/,/g' $file

# convert the header
sed -i 's/Ladezustand/soc/' $file
sed -i 's/Batterie (Laden)/battery_feed_power/' $file
sed -i 's/Batterie (Entladen)/battery_usage_power/' $file
sed -i 's/Netzeinspeisung/grid_feed_power/' $file
sed -i 's/Netzbezug/grid_usage_power/' $file
sed -i 's/Solarproduktion Tracker 1/pv_power_tracker_1/' $file
sed -i 's/Solarproduktion Tracker 2/pv_power_tracker_2/' $file
sed -i 's/Solarproduktion/pv_power/' $file
sed -i 's/Hausverbrauch/home_usage/' $file

while IFS= read -r line
do
  mydate=$(grep -Po '[0-9]{4}\-[0-9]+\-[0-9]+ [0-9]+:[0-9]+' <<< "$line") # gets date
  # perform the replacement in case there is date to process
  if [[ ! -z "$mydate" ]]; then
     newdate=$(TZ=UTC date -d"$mydate CEST" +'%FT%XZ') # converts to 2013-08-01
     sed -i "s#$mydate#$newdate#" $file       # replaces in the text (-i option)
  fi
done < $file

# convert to line influx protocol
docker run -it --rm -v $PWD:/convert -w /convert quay.io/influxdb/influxdb:2.0.0-rc bash -c 'influx write dryrun \
  -f '"${file}"' \
  --header "#constant measurement,energy" \
  --header "#datatype dateTime:RFC3339,long,long,long,long,long,long,long,long,long" > '"${timestamp}"'.influx'
