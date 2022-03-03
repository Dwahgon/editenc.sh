#!/bin/sh

if [ ! -f $1 ]; then
    >&2 echo "$0 error: $1 does not exist, or isn't a file"
    exit 1
fi

if [ -z $EDITOR ]; then 
    echo "$0 warning: No text editor has been set to \$EDITOR. Using nano instead. To suppress this warning, add 'export \$EDITOR=\"your-preferred-text-editor\"' to your .bashrc file."
    EDITOR="nano"
fi

echo -n "Encrypted file password: "
read -s PW
echo $PW | gpg --batch --passphrase-fd 0 --output /tmp/unencryptedfiletoedit -d $1
if [ $? -ne 0 ]; then exit $?; fi
$EDITOR /tmp/unencryptedfiletoedit
echo $PW | gpg --batch --yes --passphrase-fd 0 --output $1 -c /tmp/unencryptedfiletoedit
rm /tmp/unencryptedfiletoedit