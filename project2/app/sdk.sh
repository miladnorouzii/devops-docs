#!/bin/bash


# Set the working directory to the directory of the script
cd "$(dirname "$0")"

# Run the Python script
python3 main.py

# Run the Node.js script
node main.js
