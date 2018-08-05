#!/usr/bin/env bash
set -x

# Variables
fileName='aws-iam-authenticator'
dlBucket='https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/darwin/amd64/aws-iam-authenticator'
localBins='/usr/local/bin'

# Pull the binary
curl -o "$fileName" "$dlBucket"

# Verify authenticity
if [[ ! -f "$fileName" ]]; then
    echo "something went wrong; exiting! "
    exit 1
else
    openssl sha -sha256 "$fileName"
fi

# Tuck it away
chmod +x "./$fileName"
if ! mv -f "$fileName" "$localBins"; then
    echo "Dude, there was an issue moving $fileName to $localBins"
else
    echo "Looks like we're ready! "
fi

