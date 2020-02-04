#!/bin/sh
function npm_list_version () {
  local package=$1
  # stderr is just noise; it complains when node_modules doesn't exist
  listed=$(
    2>/dev/null npm list \
      --long             \
      --parseable        \
      "${package}"       \
    | cut -d: -f2        \
    | tr -d '"'
  )
  # ${listed} with ${package} prefix-removed
  suffix=${listed##${package}}
  #
  # condition 1:
  #   ${suffix} != ${listed}; ie: ${package} prefixes ${listed}
  # condition 2:
  #   ${suffix##@} != ${suffix}; ie: ${suffix} starts with '@'
  # together:
  #   ${listed} begins with ${package} and, once ${package} has been
  #   removed from the start of ${listed}, the remaining characters begin
  #   with a '@'; meaning, according to the npm version grammar, ${listed}
  #   and ${package} refer to the same @<scope>/<name> module-spec.
  #
  if :                                 \
    && [[ ${suffix}    != ${listed} ]] \
    && [[ ${suffix##@} != ${suffix} ]] \
  ; then
    echo ${listed}
  fi
}
if [[ -e "/etc/rdkafka-info.sourceme.sh" ]]; then
  source "/etc/rdkafka-info.sourceme.sh"
  if [[ -z ${NODE_RDKAFKA_INSTALL} ]]; then
    1>&2 printf '%s%s'                      \
      '$NODE_RDKAFKA_INSTALL is empty;'     \
      ' cannot find prebuilt node-rdkafka!'
    exit 1
  fi
  if [[ -z ${NODE_RDKAFKA_VERSION_EXACT} ]]; then
    1>2 printf '%s%s'                                           \
      '$NODE_RDKAFKA_VERSION_EXACT is empty;'                   \
      ' cannot check compatability with prebuilt node-rdkafka!'
    exit 1
  fi
  events_spec=$(npm_list_version "@better/events")
  if [[ -z ${events_spec} ]]; then
    1>&2 printf 'No dependency version for @better/events found!\n'
    exit 1
  fi
  events_spec_version=${events_spec##@better/events@}
  events_versions=$(
    npm info @better/events versions \
      | tr --delete "[]',"
  )
  events_satisfying=$(
    npx -q semver --range ${events_spec_version} ${events_versions}
  )
  events_exact_version=$(
    for v in ${events_satisfying}; do echo $v; done \
      | sort --version-sort --reverse               \
      | head --lines 1
  )
  events_exact="@better/events@${events_exact_version}"
  rdkafka_spec=$(npm info "${events_exact}" dependencies.node-rdkafka)
  if [[ -z ${rdkafka_spec} ]]; then
    rdkafka_spec=$(
      npm_list_version "node-rdkafka" \
        | cut -d@ -f2
    )
  fi
  if [[ -z ${rdkafka_spec} ]]; then
    1>&2 printf 'No ${rdkafka_spec} for this package could be determined!\n'
    exit 1
  fi
  if $(
    # We don't care about any of this output, only success on exit
    &>/dev/null npx -q semver       \
      --range ${rdkafka_spec}       \
      ${NODE_RDKAFKA_VERSION_EXACT}
  ); then
    if [[ ! -d "./node_modules" ]]; then mkdir "./node_modules"; fi
    rm --recursive --force ./node_modules/node-rdkafka
    echo "Copying ${NODE_RDKAFKA_INSTALL} to ./node_modules/node-rdkafka..."
    cp --recursive ${NODE_RDKAFKA_INSTALL} ./node_modules/node-rdkafka
  else
    1>&2 printf 'node-rdkafka@%s not satisfied by prebuilt @ %s\n' \
      ${rdkafka_spec} ${NODE_RDKAFKA_VERSION_EXACT}
    exit 1
  fi
else
  1>&2 printf 'no rdkafka info found at /etc/rdkafka-info.sourceme.sh\n'
  exit 1
fi
