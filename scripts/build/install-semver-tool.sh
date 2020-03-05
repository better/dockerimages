#/bin/sh -e
#
# Install semver-tool
#

# Inputs: can specify version, checksum
SEMVER_TOOL_VERSION=${SEMVER_TOOL_VERSION:-"3.0.0"}
SEMVER_TOOL_SHA256_SUM=${SEMVER_TOOL_SHA256_SUM:-"32e35a648325f8024d442adb2ee8aa16a78a4076ec3e34f6e93ef74b6d7bc142"}
# URLs: constructed from GitHub release pages
SEMVER_TOOL_URL_BASE="https://github.com/fsaintjacques/semver-tool/archive"
SEMVER_TOOL_TARGET="${SEMVER_TOOL_VERSION}.tar.gz"
SEMVER_TOOL_DOWNLOAD_URL="${SEMVER_TOOL_URL_BASE}/${SEMVER_TOOL_TARGET}"
SEMVER_TOOL_TMP_BASE="/tmp/semver-tool-${SEMVER_TOOL_VERSION}"

# Download semver-tool
curl                                                        \
  --location                                                \
  --output "/tmp/semver-tool-${SEMVER_TOOL_VERSION}.tar.gz" \
  ${SEMVER_TOOL_DOWNLOAD_URL}
# Check integrity
sha256sum "/tmp/semver-tool-${SEMVER_TOOL_VERSION}.tar.gz" \
  | grep ${SEMVER_TOOL_SHA256_SUM}
# Extract, stripping top-level `semver-tools` directory
mkdir "/tmp/semver-tool-${SEMVER_TOOL_VERSION}"
tar                                                       \
  --extract                                               \
  --verbose                                               \
  --strip-components 1                                    \
  --file "/tmp/semver-tool-${SEMVER_TOOL_VERSION}.tar.gz" \
  --directory "/tmp/semver-tool-${SEMVER_TOOL_VERSION}"
# Install semver-tool using Linux Standard Base (LSB) install
cd "/tmp/semver-tool-${SEMVER_TOOL_VERSION}"
install src/semver /usr/local/bin
# Remove the tmp-files
rm -f  "/tmp/semver-tool-${SEMVER_TOOL_VERSION}.tar.gz"
rm -rf "/tmp/semver-tool-${SEMVER_TOOL_VERSION}"
