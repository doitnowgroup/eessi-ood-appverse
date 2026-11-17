
#!/usr/bin/env bash

echo "Waiting for MLflow Server on ${host}:${port}..."

if wait_until_port_used "${host}:${port}" 60; then
    echo "MLflow Server is listening on ${host}:${port}"
else
    echo "ERROR: MLflow Server did not start."

    pkill -P "${SCRIPT_PID}" || true

    clean_up 1
fi

sleep 2
