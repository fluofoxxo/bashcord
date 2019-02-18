mkdir -p build
cpp -P bashcord.in -o build/bashcord 2>build/build.log
exit $?
