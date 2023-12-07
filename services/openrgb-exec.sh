#!/bin/bash

echo "Starting: $0.."

echo "Checking existing instance.."
echo ps fxa | grep -i /OpenRGB/openrgb
echo ps fxa | grep -i /OpenRGB/openrgb && exit

echo "Starting the server.."

PATH_TO_OPENRGB_INSTALLATION=/opt/OpenRGB

$PATH_TO_OPENRGB_INSTALLATION/openrgb --server 
