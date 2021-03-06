#!/usr/bin/env bash
set -e

echo ">>> Setting up STOP handlers..."
for f in TERM SIGTERM QUIT SIGQUIT INT SIGINT KILL SIGKILL; do
    trap "system_stop $f" "$f"
done

echo '>>> STARTING SSH (if required)...'
sshd_start

echo '>>> STARTING POSTGRES...'
/usr/local/bin/cluster/postgres/entrypoint.sh & wait ${!}

EXIT_CODE=$?
echo ">>> Foreground processes returned code: '$EXIT_CODE'"

while [ $EXIT_CODE -eq 0 ] && [ -f /var/run/postgresql/.s.PGSQL.5432.lock ]; do
    sleep 1;
done;

#while  true;  do
#    sleep 1;
#done

system_exit
exit $EXIT_CODE



