#!/usr/bin/env bash

echo "Waiting for RStudio Server on ${host}:${port}..."

if wait_until_port_used "${host}:${port}" 60; then
    echo "RStudio Server is listening on ${host}:${port}"
else
    echo "ERROR: RStudio Server did not start."
    pkill -P "${SCRIPT_PID}"
    clean_up 1
fi

sleep 2
