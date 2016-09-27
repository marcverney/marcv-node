#!/usr/bin/env bash

# Runs a command as the LOCAL_USERID if passed in, otherwise stick with root

# Check the UID
if [ "$USERID" ] \
&& [ "$USERID" != "root" ] \
&& [ "$USERID" -gt 1 ]
then
    # Create the user
    useradd --create-home --shell /bin/bash --uid "$USERID" dockeruser

    # Check the GID
    if [ "$GROUPID" ] && [ "$GROUPID" -gt 0 ]
    then
        # Create the group
        groupName=$(getent group "$GROUPID" | grep -Po '^.+?(?=:)')
        if [ ! "$groupName" ]; then
            groupName='dockeruser'
            groupadd --gid "$GROUPID" "$groupName"
        fi
        adduser --quiet dockeruser "$groupName"
    fi

    # Switch to the user
    echo "Running as user dockeruser (uid $USERID) and group $groupName the CMD: $@"
    export HOME=/home/dockeruser
    exec /usr/local/bin/gosu dockeruser "$@"
else
    echo "Running as root the CMD: $@"
    exec "$@"
fi