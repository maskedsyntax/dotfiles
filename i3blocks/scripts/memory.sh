#!/bin/bash
# memory.sh

# Look for the "Mem:" line and compute usage.
# Then use int() to round down and append a single '%' with 'print'.
free | awk '/Mem:/ { print int($3 / $2 * 100) "%"}'

