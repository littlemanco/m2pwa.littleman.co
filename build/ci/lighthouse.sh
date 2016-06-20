#!/bin/bash

# Ensure lighthouse exists
lighthouse --version || npm install -g lighthouse

# Run the required chrome
npm explore -g lighthouse -- npm run chrome &

# Run lighthouse
lighthouse http://dev.m2pwa.littleman.co

