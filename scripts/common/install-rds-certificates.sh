#/bin/sh -e
# Install RDS Database SSL certificates.
mkdir -p /etc/ssl

curl                                     \
  -o /etc/ssl/rds-combined-ca-bundle.pem \
  -L https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem

curl                                 \
  -o /etc/ssl/redshift-ca-bundle.crt \
  -L https://s3.amazonaws.com/redshift-downloads/redshift-ca-bundle.crt

update-ca-certificates
