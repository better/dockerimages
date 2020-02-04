#!/bin/sh
if [[ -e "/etc/rdkafka-info.sourceme.sh" ]]; then
  source "/etc/rdkafka-info.sourceme.sh"
  if [[ -z $NODE_RDKAFKA_INSTALL ]]; then
    >2 printf '%s%s'                        \
      '$NODE_RDKAFKA_INSTALL is empty;'     \
      ' cannot find prebuilt node-rdkafka!'
    exit 1
  fi
  if [[ -z $NODE_RDKAFKA_VERSION_EXACT ]]; then
    >2 printf '%s%s'                                            \
      '$NODE_RDKAFKA_VERSION_EXACT is empty;'                   \
      ' cannot check compatability with prebuilt node-rdkafka!'
    exit 1
  fi
  events_exact=$(
    # stderr is just noise; it complains when node_modules doesn't exist
    2>/dev/null npm list \
        --long           \
        --parseable      \
        @better/events   \
      | cut -d: -f2      \
      | tr -d '"'
  )
  rdkafka_spec=$(
    npm info                    \
      "${events_exact}"         \
      dependencies.node-rdkafka
  )
  if $(
    # We don't care about any of this output, only success on exit
    &>/dev/null npx semver          \
      --range ${rdkafka_spec}       \
      ${NODE_RDKAFKA_VERSION_EXACT}
  ); then
    if [[ ! -d "./node_modules" ]]; then mkdir "./node_modules"; fi
    rm --recursive --force ./node_modules/node-rdkafka
    echo "Copying $NODE_RDKAFKA_INSTALL to ./node_modules/node-rdkafka..."
    cp --recursive $NODE_RDKAFKA_INSTALL ./node_modules/node-rdkafka
  fi
fi
