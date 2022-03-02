#!/bin/sh

if [ ! -f $1 ]; then
    >&2 echo "$0 error: $1 does not exist, or isn't a file"
    exit 1
fi

DEFAULT_EDITOR="kate"

echo -n "Encrypted file password: "
read -s PW
echo $PW | gpg --batch --passphrase-fd 0 --output /tmp/unencryptedfiletoedit -d $1
if [ $? -ne 0 ]; then exit $?; fi
$DEFAULT_EDITOR /tmp/unencryptedfiletoedit
echo $PW | gpg --batch --yes --passphrase-fd 0 --output $1 -c /tmp/unencryptedfiletoedit
rm /tmp/unencryptedfiletoedit