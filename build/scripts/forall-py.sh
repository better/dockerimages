#!/bin/bash
source /etc/profile

pyenv shell $PYENV_VERSIONS
pyenv_versions=$(pyenv versions | grep '\*' | awk '{print $2}')

for version in $pyenv_versions; do
    echo Running $* in Python $version...
    pyenv shell $version
    pyenv exec $*
    echo Running $* in Python $version...done
    echo
    done
