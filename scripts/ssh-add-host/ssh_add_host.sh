#!/bin/bash

# VARIABLES
set CUSTOM_HOST
set CUSTOM_HOSTNAME
set CUSTOM_USER
set CUSTOM_IDENTITY_FILE
set CUSTOM_PORT
#

if [ ! -f ~/.ssh/config ]
then
    touch ~/.ssh/config
fi

# HOST
echo "Enter a name for your host:"
read CUSTOM_HOST
#

# HOSTNAME
echo "Enter your host's address:"
read CUSTOM_HOSTNAME
#

# USER
echo "Enter a username:"
read CUSTOM_USER
#

# IDENTITY
echo "Enter the identity file (default=~/.ssh/id_rsa):"
read CUSTOM_IDENTITY_FILE

if [ "$CUSTOM_IDENTITY_FILE" == "" ]
then
    CUSTOM_IDENTITY_FILE=~/.ssh/id_rsa
fi
#

# PORT
echo "Enter a port (default=22):"
read CUSTOM_PORT

if [ "$CUSTOM_PORT" == "" ]
then
    CUSTOM_PORT=22
fi
#

# ADD HOST TO ~/.SSH/CONFIG
echo "Host $CUSTOM_HOST" >> ~/.ssh/config
echo "  HostName $CUSTOM_HOSTNAME" >> ~/.ssh/config
echo "  User $CUSTOM_USER" >> ~/.ssh/config
echo "  Port $CUSTOM_PORT" >> ~/.ssh/config
echo "  IdentityFile $CUSTOM_IDENTITY_FILE" >> ~/.ssh/config