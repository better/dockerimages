#/bin/sh -e
# Install sops
# Inputs: can specify version, checksum
SOPS_VERSION=${SOPS_VERSION:-"3.3.1"}
SOPS_SHA1_SUM=${SOPS_SHA1_SUM:-"af2fc3d3a29565b0d6a73249136965ffee62892f"}
# URLs: constructed from version/GitHub release page pattern
SOPS_URL_BASE="https://github.com/mozilla/sops/releases/download"
SOPS_TARGET="${SOPS_VERSION}/sops-${SOPS_VERSION}.linux"
SOPS_DOWNLOAD_URL="${SOPS_URL_BASE}/${SOPS_TARGET}"

# Download sops
curl -o sops -L ${SOPS_DOWNLOAD_URL}
# Check its integrity
sha1sum sops | grep ${SOPS_SHA1_SUM}
# Set the executable bit
chmod +x sops
# Move it into ${PATH}
mv sops /usr/local/bin
