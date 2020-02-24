#!/bin/bash

# echo $#

rpkg_priority=0
ros_reset=0

usage()
{
    echo "usage: $0 -p /opt/openrobots [-R] [-r] [-h]"
    echo "   -p: [required] path to robotpkg install directory"
    echo "   -R: [optional] source ROS release setup.bash file"
    echo "   -r: [optional] robotpkg has the highest priority"
}

verboseinfo()
{
    echo "ROS reset: $ros_reset"
    echo "Robotpkg priority: $rpkg_priority"
    echo "ROS_PACKAGE_PATH: $ROS_PACKAGE_PATH"
    echo "rpkg_path: $rpkg_path"
}

# Dealing with parameters
while [ "$1" != "" ]; do
    case $1 in
        -p | --rpkg-path )      shift
                                rpkg_path=$1
                                ;;
        -R | --ros-reset )      ros_reset=1
                                ;;
        -r | --rpkg-priority )  rpkg_priority=1
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

# Detect Ubuntu release
if [ -f /etc/lsb-release ]; then
    (. /etc/lsb-release; 
     echo "#!/bin/bash" > /tmp/local.bash
     echo "export DISTRIB_CODENAME="$DISTRIB_CODENAME >> /tmp/local.bash;
     echo "export DISTRIB_RELEASE="$DISTRIB_RELEASE >> /tmp/local.bash;
     echo "export DISTRIB_DESCRIPTION=\""$DISTRIB_DESCRIPTION\" >> /tmp/local.bash;)
    source /tmp/local.bash
fi

if [ $ros_reset -eq 1 ]; then
  echo "Reset ROS" 
  # If the release is 12.04 LTS
  if [ $DISTRIB_RELEASE == "12.04" ]; then
    # ROS is set to Hydro 
    source /opt/ros/hydro/setup.bash
  fi 

  # If the release is 14.04 LTS
  if [ $DISTRIB_RELEASE == "14.04" ]; then
    # ROS is set to Indigo 
    source /opt/ros/indigo/setup.bash
  fi 

  # If the release is 16.04 LTS
  if [ $DISTRIB_RELEASE == "16.04" ]; then

    # Specific Machine architecture
    export MACHINE_ARCH=x86_64
    
    # ROS is set to Indigo 
    source /opt/ros/kinetic/setup.bash
  fi
fi

if [ $rpkg_priority -eq 1 ];
then
  export ROBOTPKG_BASE=$rpkg_path
  export PATH=$ROBOTPKG_BASE/sbin:$ROBOTPKG_BASE/bin:$PATH
  export LD_LIBRARY_PATH=$ROBOTPKG_BASE/lib:$ROBOTPKG_BASE/lib/plugin:$ROBOTPKG_BASE/lib64:$LD_LIBRARY_PATH
  export PYTHONPATH=$ROBOTPKG_BASE/lib/python2.7/site-packages:$ROBOTPKG_BASE/lib/python2.7/dist-packages:$PYTHONPATH
  export PKG_CONFIG_PATH=$ROBOTPKG_BASE/lib/pkgconfig/:$PKG_CONFIG_PATH
  export ROS_PACKAGE_PATH=$ROBOTPKG_BASE/share:$ROBOTPKG_BASE/stacks:$ROS_PACKAGE_PATH
  export CMAKE_PREFIX_PATH=$ROBOTPKG_BASE:$CMAKE_PREFIX_PATH
else
  export ROBOTPKG_BASE=$rpkg_path
  export PATH=$PATH:$ROBOTPKG_BASE/sbin:$ROBOTPKG_BASE/bin
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROBOTPKG_BASE/lib:$ROBOTPKG_BASE/lib/plugin:$ROBOTPKG_BASE/lib64
  export PYTHONPATH=$PYTHONPATH:$ROBOTPKG_BASE/lib/python2.7/site-packages:$ROBOTPKG_BASE/lib/python2.7/dist-packages
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$ROBOTPKG_BASE/lib/pkgconfig/
  export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$ROBOTPKG_BASE/share:$ROBOTPKG_BASE/stacks
  export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$ROBOTPKG_BASE
fi
