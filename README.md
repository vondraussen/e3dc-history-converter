# Prepare the Export
the file must look lile:
```
timestamp;Ladezustand;Batterie (Laden);Batterie (Entladen);Netzeinspeisung;Netzbezug;Solarproduktion Tracker 1;Solarproduktion Tracker 2;Solarproduktion;Hausverbrauch
2020-09-03T00:00:00Z,90,0,68,1,1,0,0,0,53
2020-09-03T00:15:00Z,90,0,64,0,0,0,0,0,49
```
1. convert ; to ,
2. add newline at the end of the file
3. convert the header (replace spaces and braces)
4. conver the time to UTC
    + it is in this format TZ=Europa/Berlin: 2020-09-03 00:00
    + it has to be in this format: 2020-09-03T22:00:00Z

# Use the influxdb 2.0 converter
```bash
# convert to line influx protocol
docker run -it --rm -v $PWD:/convert -w /convert quay.io/influxdb/influxdb:2.0.0-rc bash

influx write dryrun \
  -f e3d.csv \
  --header "#constant measurement,energy" \
  --header "#datatype dateTime:RFC3339,long,long,long,long,long,long,long,long,long"
```