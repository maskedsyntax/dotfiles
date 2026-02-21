#!/bin/bash
# disconnect_bt.sh
# This script lists connected Bluetooth devices and lets you select one to disconnect.

# Gather all known Bluetooth devices from bluetoothctl.
all_devices=$(bluetoothctl devices | awk '{print $2}')

# Array to store only the connected devices.
connected_devices=()
declare -A device_map

echo "Checking for connected Bluetooth devices..."
i=1
for mac in $all_devices; do
  # Check connection status for each device.
  if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
    # Get the device name (if available).
    name=$(bluetoothctl info "$mac" 2>/dev/null | grep "Name:" | cut -d ' ' -f2-)
    # Fallback if no name is provided.
    [ -z "$name" ] && name="Unknown"
    echo "  $i) $name ($mac)"
    device_map[$i]="$mac"
    connected_devices+=("$mac")
    ((i++))
  fi
done

# Exit if no devices are connected.
if [ ${#connected_devices[@]} -eq 0 ]; then
  echo "No connected Bluetooth devices found."
  exit 0
fi

echo ""
read -p "Enter the number of the device you want to disconnect: " selection

# Validate the selection.
if [ -z "${device_map[$selection]}" ]; then
  echo "Invalid selection. Exiting."
  exit 1
fi

selected_mac="${device_map[$selection]}"
echo "Disconnecting device with MAC: $selected_mac..."
bluetoothctl disconnect "$selected_mac"

# Give it a moment, then confirm disconnection.
sleep 2
if bluetoothctl info "$selected_mac" 2>/dev/null | grep -q "Connected: no"; then
  echo "Device $selected_mac has been disconnected."
else
  echo "There was a problem disconnecting the device. Please try again."
fi

