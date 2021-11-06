#!bin/bash

function usage() {
	echo "Usage: build.sh [-d <directory>] [-n <name>] [-v <version>] (-A <aggressive>)" 1>&2
	read -p "Press return/enter to exit"
	exit 0
}

Agg="false"
while getopts "hd:n:v:A" flag; do
    case "$flag" in
        d)
            dir=${OPTARG}
            ;;
        n)
            name=${OPTARG}
            ;;
        v)
            ver=${OPTARG}
            ;;
		A)
			Agg="true"
            ;;
		*)
			usage
            ;;
    esac
done

start_time=`date +%s`

root=$(pwd)
build_path="${dir}/${name}-${ver}.rbxlx"

echo "Syncing tarmac managed assets"
tarmac sync --target roblox
echo "Synced tarmac assets to project"

echo "Running rojo build"
rojo build -o "${build_path}"
[ ! -f "${build_path}" ] && echo "Rojo build failed, exiting with non-zero status code" && exit -1
echo "Rojo build successful..."

echo "Running remodel scripts and manipulating files"
remodel run scripts/remodel/generate-build.lua "${dir}" "${name}" "${ver}" "*.lua" "Assets/img"
echo "Remodel has finished manipulating the target build"

end_time=`date +%s`
echo Build generated in `expr $end_time - $start_time`s.

if [ $Agg == "true" ]; then
    # Run git shell commands
    echo "Aggressive build started, staging files..."
    echo "Comitting changes..."
    read -p "Which remote are you targeting? " remote
    read -p "Which branch are you targeting? " branch
    echo "Pushing changes to ${remote}:${branch}"

    final_end=`date +%s`
    echo Release took `expr $final_end - $end_time`s

    read -p "Press return/enter to exit"
    exit 0
else # Skip git actions
    echo "Non-aggressive build, git shell bypassed, finished building" 
    echo "Build is available @<${root}/${build_path}>"
    read -p "Press return/enter to exit"
    exit 0
fi