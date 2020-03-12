# pseudo-oe

PseudoDesign's openembedded build environment

## Rake

Commands are built around the rake build environment.  Type "rake -T" to see available commands

## *-build/conf/priv-local.conf

An optional file, included in the gitignore, that is added to local.conf in rake commands for `dev` builds.  Use this to store data you don't want to add to a repository or release build, such as development keys.
