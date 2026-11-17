#!/usr/bin/env bash

echo "Waiting for TensorBoard on ${host}:${port}..."

if wait_until_port_used "${host}:${port}" 60; then
    echo "TensorBoard is listening on ${host}:${port}"
else
    echo "ERROR: TensorBoard did not start."

    pkill -P "${SCRIPT_PID}" || true

    clean_up 1
fi

sleep 2
