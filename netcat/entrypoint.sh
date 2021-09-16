#!/bin/bash
# netcat listen 123
ncat -lnvp 123 -e /bin/bash &

echo "To receive the reverse shell, only write:"
echo " > nc -nv CONTAINER-IP 123"

while [ 1 ]; do
        sleep 6000
done
