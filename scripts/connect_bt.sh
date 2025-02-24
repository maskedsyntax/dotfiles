#!/bin/bash
# connect_bt.sh
# This script scans for Bluetooth devices, shows a menu of discovered devices,
# and then attempts to pair, trust, and connect to the device you select.
#
# Usage: ./connect_bt.sh

# Ensure Bluetooth is powered on and the agent is active.
bluetoothctl power on > /dev/null 2>&1
bluetoothctl agent on > /dev/null 2>&1
bluetoothctl default-agent > /dev/null 2>&1

echo "Scanning for Bluetooth devices..."
# Start scanning in the background.
bluetoothctl scan on > /dev/null 2>&1 &
SCAN_PID=$!

# Allow time for discovery. Adjust sleep duration as needed.
sleep 10

# Stop scanning.
bluetoothctl scan off > /dev/null 2>&1

# In case the background scan process is still running, try to terminate it.
kill $SCAN_PID 2>/dev/null

# Get the list of discovered devices.
DEVICES=$(bluetoothctl devices)

if [ -z "$DEVICES" ]; then
  echo "No Bluetooth devices found. Exiting."
  exit 1
fi

echo ""
echo "Discovered devices:"
# Use an associative array to map menu numbers to device MAC addresses.
declare -A device_map
i=1

# Process each line of output. Lines have the format:
#   Device AA:BB:CC:DD:EE:FF Device_Name
while IFS= read -r line; do
    # Extract the MAC address and the device name.
    mac=$(echo "$line" | awk '{print $2}')
    name=$(echo "$line" | cut -d ' ' -f3-)
    # If the device name is empty, mark it as unknown.
    if [ -z "$name" ]; then
        name="Unknown"
    fi
    echo "  $i) $name ($mac)"
    device_map[$i]="$mac"
    ((i++))
done < <(echo "$DEVICES")

echo ""
# Prompt the user to select a device.
read -p "Enter the number of the device you want to connect to: " selection

# Validate the selection.
if [ -z "${device_map[$selection]}" ]; then
  echo "Invalid selection. Exiting."
  exit 1
fi

selected_mac="${device_map[$selection]}"
echo "You selected device with MAC: $selected_mac"

echo "Attempting to pair, trust, and connect to $selected_mac..."

# Use a here-document to send commands to bluetoothctl.
bluetoothctl <<EOF
pair $selected_mac
trust $selected_mac
connect $selected_mac
exit
EOF

# Give the connection a moment to establish.
sleep 3

# Check the connection status.
if bluetoothctl info "$selected_mac" | grep -q "Connected: yes"; then
  echo "Successfully connected to $selected_mac."
else
  echo "Failed to connect to $selected_mac. Please check your device and try again."
fi

