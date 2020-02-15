#!/usr/bin/env bash

version_weight () {
  echo -e "$1" | tr ' ' "\n"  | \
    sed -Ee 's:^([0-9]+)\.([0-9]+)\.([0-9]+)$:&:' | \
    sed -Ee 's:^([0-9]+)\.([0-9]+)$:&.x:' | \
    sed -Ee 's:^([0-9]+)$:&.x.x:'
}
tags_orig=($(cat))
tags_weight=( $(version_weight "${tags_orig[*]}") )

for y in ${tags_weight[*]}; do echo ${y}; done | sort -r | sed -Ee 's:\.x::g'
