#!/bin/sh

# Install common dependancies
apk add --no-cache coreutils bash ca-certificates openssl curl wget

# Database SSL certificates
mkdir -p /etc/ssl && \
curl -o /etc/ssl/rds-combined-ca-bundle.pem -L https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem && \
curl -o /etc/ssl/redshift-ca-bundle.crt -L https://s3.amazonaws.com/redshift-downloads/redshift-ca-bundle.crt && \
update-ca-certificates

# Install sops
curl -o sops -L https://github.com/mozilla/sops/releases/download/3.3.1/sops-3.3.1.linux && \
sha1sum sops | grep af2fc3d3a29565b0d6a73249136965ffee62892f && \
chmod +x sops && \
mv sops /usr/local/bin
