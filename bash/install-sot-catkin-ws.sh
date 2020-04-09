#!/bin/bash
#
# Install SoT catkin SoT workspace
# Olivier Stasse
# CNRS, LAAS 2020
#

# echo $#

pinocchio_pkgconfig_present=0
id_step=1
nb_steps=6
usage()
{
    echo "usage: $0 -p ~/sot_ws "
    echo "   -p: [required] path to SoT catkin workspace"
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

# Check if pinocchio is available through pkg-config
checking_pinocchio_pkg_config()
{
    echo "* ${purple}[$id_step/$nb_steps]${std} Check if pinocchio is present"
    pinocchio_exists=0
    REQPKG=pinocchio
    if pkg-config --exists pinocchio; then
        pinocchio_exists=1
    fi
    if [ $pinocchio_exists -eq 1 ]; then
        echo "${green}Found pinocchio${std}"
    fi
    id_step=$((id_step+1))
}

# Check if a command is installed
checking_if_a_command_is_installed()
{
    # Type test if command give as parameter $1 is present
    if type $1 >/dev/null 2>&1; then
        echo "${green}Found $1 ${std}"
    else
        echo "${red}$1 not present${std}: apt install $2"
    fi
}

executable_names=( "vcs" "wget" "catkin" )
package_names=( "python3-vcstool" "wget" "python-catkin-tools" )

# Checking if all the commands are installed
checking_if_commands_are_installed()
{
    echo "* ${purple}[$id_step/$nb_steps]${std} Check if commands are installed"
    for i in  ${!executable_names[@]}; do
        checking_if_a_command_is_installed ${executable_names[$i]} ${packages_names[$i]}
    done
    id_step=$((id_step+1))
}

# Prepare SoT workspace directoy
prepare_sot_ws_directory()
{
    echo "* ${purple}[$id_step/$nb_steps]${std} Prepare SoT workspace directory"
    if [ ! -d $rpkg_path ]; then
        mkdir -p $rpkg_path
        if [ -d $rpkg_path ]; then
            echo "${green}$rpkg_path has been created ${std}"
        fi
    else
        echo "${yellow}$rpkg_path already exists${std}"
    fi
    id_step=$((id_step+1))
}

get_sot_repos()
{
    echo "* ${purple}[$id_step/$nb_steps]${std} Get sot_talos.repos"
    cd ${rpkg_path}
    wget -O sot_talos.repos https://raw.githubusercontent.com/stack-of-tasks/sot-doc/master/config/sot_talos.repos
    id_step=$((id_step+1))
    echo "* ${purple}[$id_step/$nb_steps]${std} Import all repositories (around 800 Mo)"
    vcs import --recursive < sot_talos.repos
    id_step=$((id_step+1))
}

configure_catkin()
{
    cd ${rpkg_path}
    echo "* ${purple}[$id_step/$nb_steps]${std} Configure catkin"
    local_cmake_args="--cmake-args -DCMAKE_BUILD_TYPE=RELEASE "
    local_cmake_args="${local_cmake_args} -DPYTHON_STANDARD_LAYOUT:BOOL=ON"
    local_cmake_args="${local_cmake_args} -DPYTHON_DEB_LAYOUT:BOOL=OFF"
    local_cmake_args="${local_cmake_args} -DSETUPTOOLS_DEB_LAYOUT:BOOL=OFF"
    local_cmake_args="${local_cmake_args} -DCMAKE_CXX_FLAGS=\"-std=c++11\""
    catkin_config_args="--install -w $rpkg_path"
    catkin_config_args="${catkin_config_args} ${local_cmake_args}"
    catkin config ${catkin_config_args} --
    id_step=$((id_step+1))
    echo "catkin config ${catkin_config_args} --"
}

# Dealing with parameters
while [ "$1" != "" ]; do
    case $1 in
        -p | --rpkg-path )      shift
                                rpkg_path=$1
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

# Main starts from here
checking_if_commands_are_installed

checking_pinocchio_pkg_config

prepare_sot_ws_directory

get_sot_repos

configure_catkin
