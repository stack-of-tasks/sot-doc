#!/bin/bash
#
# Install SoT dependencies through robotpkg
# Olivier Stasse 
# CNRS, LAAS 2020
#

usage()
{
    echo "usage: $0 -p /opt/openrobots -s /opt/openrobots/robotpkg-src "
    echo "   -p: [required] path to robotpkg install dir [default:/opt/openrobots]"
    echo "   -s: [required] path to robotpkg source dir [default/opt/openrobots/robotpkg-src]"
}

set_colors()
{
  red='[0;31m';    lred='[1;31m'
  green='[0;32m';  lgreen='[1;32m'
  yellow='[0;33m'; lyellow='[1;33m'
  blue='[0;34m';   lblue='[1;34m'
  purple='[0;35m'; lpurple='[1;35m'
  cyan='[0;36m';   lcyan='[1;36m'
  grey='[0;37m';   lgrey='[1;37m'
  white='[0;38m';  lwhite='[1;38m'
  std='[m'
}

set_nocolors()
{
  red=;    lred=
  green=;  lgreen=
  yellow=; lyellow=
  blue=;   lblue=
  purple=; lpurple=
  cyan=;   lcyan=
  grey=;   lgrey=
  white=;  lwhite=
  std=
}


verboseinfo()
{
    echo "ROS_PACKAGE_PATH: $ROS_PACKAGE_PATH"
    echo "rpkg_path: $rpkg_path"
}

generate_json_file()
{
    echo "{\"arch_dist_files\": \"arch_distfiles\"," > arch_test_sot_only.json
    echo " \"archives\": \"archives\"," >> arch_test_sot_only.json
    echo " \"ramfs_mnt_pt\": \"$rpkg_path\"," >> arch_test_sot_only.json
    echo " \"repo_robotpkg_wip\": \"https://git.openrobots.org/robots/robotpkg/robotpkg-wip.git\"," >> arch_test_sot_only.json
    echo " \"repo_robotpkg_main\": \"https://git.openrobots.org/robots/robotpkg.git\","  >> arch_test_sot_only.json
    echo " \"robotpkg_mng_root\": \"$rpkg_path/..\"," >> arch_test_sot_only.json
    echo " \"robotpkg_mng_base\": \"$rpkg_path\"," >> arch_test_sot_only.json
    echo " \"robotpkg_mng_src\": \"$rpkg_src_path\"," >> arch_test_sot_only.json
    echo " \"rc_pkgs\": {}," >> arch_test_sot_only.json
    echo " \"ssh_git_openrobots\": false, " >> arch_test_sot_only.json
    echo " \"targetpkgs\": [\"py-eigenpy\"," >> arch_test_sot_only.json
    echo "    \"pinocchio\",\"py-pinocchio\"," >> arch_test_sot_only.json
    echo "    \"eiquadprog\",\"simple-humanoid-description\"," >> arch_test_sot_only.json
    echo "    \"parametric-curves\",\"talos-simulation\"]">> arch_test_sot_only.json
    echo "}" >> arch_test_sot_only.json
}

extract_robotpkg_helpers()
{
    if [ ! -d $rpkg_path ]; then
        mkdir -p $rpkg_path
    fi
    if [ ! -d $rpkg_src_path ]; then
        mkdir -p $rpkg_src_path
    fi
    cd $rpkg_src_path
    git clone https://github.com/olivier-stasse/robotpkg_helpers.git
    cd robotpkg_helpers/tools
    generate_json_file
    ./rpkgh_build_arch_rc.py ./arch_test_sot_only.json
}

# Dealing with parameters
while [ "$1" != "" ]; do
    case $1 in
        -p | --rpkg-install-path )      shift
                                rpkg_path=$1
                                ;;
        -s | --rpkg-source-path )      shift
                                rpkg_src_path=$1
                                ;;
        -v | --verbose )        verboseinfo
                                exit
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# Define colors if stdout is a tty.
if test -t 1; then
  set_colors
else # stdout isn't a tty => don't print colors.
  set_nocolors
fi

if [ -z "$rpkg_path" ]; then
    echo "${red}Please define -p rpkg_path${std}"
    usage
    exit -1    
fi

if [ -z "$rpkg_src_path" ]; then
    echo "${red}Please define -s rpkg_src_path${std}"
    usage
    exit -1    
fi


extract_robotpkg_helpers
