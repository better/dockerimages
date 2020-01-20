#!/usr/bin/env bash

. ./semver.sh

if [[ $# -eq 0 ]] ; then
    echo 'USAGE: bash release.sh <IMAGE TAG> <VERSION>'
    exit 0
fi

image=$1
version=$2
MAJOR=0
MINOR=0
PATCH=0
SPECIAL=""
semverParseInto "${version}" MAJOR MINOR PATCH SPECIAL

tags=()
defaultTags=(${image}-${MAJOR} ${image}-${MAJOR}.${MINOR} ${image}-${MAJOR}.${MINOR}.${PATCH})

if [ -z $SPECIAL ] ; then
  tags=(${defaultTags[@]})

  while true; do
    read -p "Is ${image}-${version} also the latest version (y/n)? " latest
    case $latest in
      [Yy]* ) tags+=(${image}-latest); break;;
      [Nn]* ) break;;
      * ) echo "You must answer yes or no";;
    esac
  done
else
  tags=(${image}-${MAJOR}.${MINOR}.${PATCH}${SPECIAL})
fi

echo "Planning to tag this commit with the following tags:"
for tag in "${!tags[@]}"; do
  printf "%s\t%s\n" "$((tag+1))" "${tags[$tag]}"
done

echo ""

while true; do
  read -p "Proceed with upating these tags (y/n)? " proceed
  case $proceed in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "You must answer yes or no";;
  esac
done

echo ""

echo "Updating tags..."

for tag in "${tags[@]}"; do
  echo "Tagging ${tag}"
  git tag -f $tag

  echo "Pushing ${tag}"
  git push -f origin ${tag}
done
