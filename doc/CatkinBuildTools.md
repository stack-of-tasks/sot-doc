# Using catkin tools and vcs for the SoT {#memo_catkin_tools}

\section memo_catkin_tools_intro Introduction

This memo explains how to handle a super build (set of packages) workspace of the SoT with catkin tools.
catkin tools should not confused with catkin_make. They can be installed independently from ROS.

\subsection memo_catkin_tools_quick_start Quick start

If you do not have all the source dependencies please follow the steps given in \ref memo_preparing_environment.

Once this is done, to create your SoT workspace:

    mkdir sot_ws
    vcs import --recursive < sot_talos.repos
    catkin build

That's it.


\section memo_catkin_tools_vcs Handling the repositories (VCS)


\subsection memo_catkin_tools_vcs_checkingout Checking out the SoT infra-structure

The set of repositories can be handled using the [vcs software]
(https://github.com/dirk-thomas/vcstool)

The repositories for the SoT can be specified in a file sot_talos.repos as follows:

    repositories:
        others/robotpkg_helpers:
            type: git
            url: https://github.com/stack-of-tasks/robotpkg_helpers.git
            version: master
        src/dynamic-graph:
            type: git
            url: https://github.com/stack-of-tasks/dynamic-graph.git
            version: master
        src/dynamic-graph-python:
            type: git
            url: https://github.com/stack-of-tasks/dynamic-graph-python.git
            version: master
        src/dynamic_graph_bridge:
            type: git
            url: https://github.com/stack-of-tasks/dynamic_graph_bridge.git
            version: master
        src/dynamic_graph_bridge_msgs:
            type: git
            url: https://github.com/stack-of-tasks/dynamic_graph_bridge_msgs.git
            version: master
        src/jrl-walkgen:
            type: git
            url: https://github.com/stack-of-tasks/jrl-walkgen.git
            version: master
        src/roscontrol_sot:
            type: git
            url: https://github.com/stack-of-tasks/roscontrol_sot.git
            version: master
        src/sot-core:
            type: git
            url: https://github.com/stack-of-tasks/sot-core.git
            version: master
        src/sot-dynamic-pinocchio:
            type: git
            url: https://github.com/stack-of-tasks/sot-dynamic-pinocchio.git
            version: master
        src/sot-pattern-generator:
            type: git
            url: https://github.com/stack-of-tasks/sot-pattern-generator.git
            version: master
        src/sot-talos:
            type: git
            url: https://github.com/stack-of-tasks/sot-talos.git
            version: master
        src/sot-talos-balance:
            type: git
            url: https://github.com/loco-3d/sot-talos-balance.git
            version: master
        src/sot-tools:
            type: git
            url: https://github.com/stack-of-tasks/sot-tools.git
            version: master
        src/sot-torque-control:
            type: git
            url: https://github.com/stack-of-tasks/sot-torque-control.git
            version: master
        src/talos_data:
            type: git
            url: https://github.com/stack-of-tasks/talos_data.git
            version: master
        src/talos_metapkg_ros_control_sot:
            type: git
            url: https://github.com/stack-of-tasks/talos_metapkg_roscontrol_sot.git
            version: master
        src/tsid:
            type: git
            url: https://github.com/stack-of-tasks/tsid.git
            version: master

To import all the repositories:

    vcs import --recursive < sot_talos.repos


You can create your own file by going in the src directory of your workspace, and then type:

    vcs export --repos > sot_talos.repos


\subsection memo_catkin_tools_vcs_status Getting the current status of the repos
In the src directory of the workspace

    vcs status -quiet

\subsection memo_catkin_tools_vcs_status Updating the repos
In the root directory of the worspace

    vcs pull

This will pull the current branch from its upstream remote server.


\section memo_catkin_tools_compiling Compiling and testing the packages (catkin)

\subsection memo_catkin_tools_compiling_settings Setting the cmake args
For instance we want to force the system to be in debug mode
and to set some variables we can use the following command:

    catkin config --install --cmake-args -DCMAKE_BUILD_TYPE=DEBUG

It forces the package to be installed in the install folder,
and forces all the CMake aware packages to be compiled in DEBUG mode.

A more involved example is the following:

    local_cmake_args="--cmake-args -DCMAKE_BUILD_TYPE=DEBUG "
    local_cmake_args="${local_cmake_args} -DPYTHON_STANDARD_LAYOUT:BOOL=ON"
    local_cmake_args="${local_cmake_args} -DPYTHON_DEB_LAYOUT:BOOL=OFF"
    local_cmake_args="${local_cmake_args} -DSETUPTOOLS_DEB_LAYOUT:BOOL=OFF"
    catkin_config_args="--install -w $HOME/devel-src/sot_bionic_ws"
    catkin_config_args="${catking_config_args} ${local_cmake_args}"
    catkin config ${catkin_config_args} --


\subsection memo_catkin_tools_compiling_compiling Compiling

\subsubsection memo_catkin_tools_compiling_all Compiling everything

    catkin build


\subsubsection memo_catkin_tools_compiling_a_pkg Compiling a specific package with its dependencies
For instance the following command is compiling the dynamic-graph-python
package:


    catkin build dynamic-graph-python


\subsubsection memo_catkin_tools_compiling_a_pkg_nodeps Compiling a specific package without its dependencies
For instance the following command is compiling the dynamic-graph-python
package:


    catkin build dynamic-graph-python --no-deps

\subsubsection memo_catkin_tools_compiling_a_pkg_doc Generating the documentation
For instance the following command is generating the documentation for the sot-core
package:

    catkin build sot-core --no-deps --make-args doc

\subsection memo_catkin_tools_clean_all Clean all the build part

    catkin clean

\subsection memo_catkin_tools_run_tests Running tests
Example running the test programs of the package dynamic-graph-python in the workspace root directory:


    catkin test dynamic-graph-python

Note: make sure that the install directory is specified in the environment variables LD_LIBRARY_PATH and PYTHONPATH for instance.
By default *all* dependent packages will also run the tests. To prevent this it is highly recommended to use:


    catkin test dynamic-graph-python --no-deps


\subsection memo_catkin_tools_compute_coverage Computing coverage

You need to add to the CXX_FLAGS and the LD_FLAGS the value --coverage:


    catkin config --append --cmake-args -DCMAKE_CXX_FLAGS="--coverage" -DCMAKE_LD_FLAGS="--coverage"


Then run the test:

    catkin test dynamic-graph-python


And in the workspace root directory you need to run:

    gcovr -r . --html --html-details -o ./logs/coverage/index.html


To get the output of the coverage:

    firefox ./logs/coverage/index.html


\section memo_preparing_environment Installing dependencies

They are several ways to install the dependencies of the SoT from sources in a target directory ```target_dir```
We gave here two methods to install the necessary software environment for the Stack-of-Tasks.
To illustrate the process the Talos humanoid robot related packages are used.

\subsection subsec_preparing_env_from_rpkg_only Robotpkg Only

You need to install the package management system robotpkg as detailed in \ref installation_from_source .
During the procedure make sure that prefix is set to ```target_dir```.

\subsection subsec_preparing_env_from_rpkg_helpers Robotpkg helpers repository

Clone the following repository :

    git clone robotpkg_helpers https://github.com/olivier-stasse/robotpkg_helpers

Modifies the following JSON file:

    {"arch_dist_files": "arch_distfiles",
     "archives": "archives",
     "ramfs_mnt_pt": "openrobots",
     "repo_robotpkg_wip": "https://git.openrobots.org/robots/robotpkg/robotpkg-wip.git",
     "repo_robotpkg_main": "https://git.openrobots.org/robots/robotpkg.git",
     "robotpkg_mng_root": "/integration_tests",
     "robotpkg_mng_base": "/integration_tests/openrobots",
     "robotpkg_mng_src": "/integration_tests/test-openrobots-src",
     "rc_pkgs":
     {},
     "ssh_git_openrobots": false,
     "targetpkgs": ["talos-dev"]
    }

You can set the variable ```robotpkg_mng_base``` to ```target_dir```. This where all the binaries, libraries, ros packages and documentation will be installed.
The variable ```robotpkg_mng_src``` specifies where the robotpkg sources are stored.

\subsection subsec_preparing_env_chaining_ws Chaining workspaces

To chain the workspace you can either follow this tutorial

    http://wiki.ros.org/catkin/Tutorials/workspace_overlaying

with the workspace where all the SoT packages are located, or make an alias calling the script
[setup-opt-testrobotpkgarg.sh](https://github.com/stack-of-tasks/sot-doc/blob/master/bash/setup-opt-testrobotpkgarg.sh)

    source setup-opt-testrobotpkgarg.sh -p target_dir -r
    source setup-opt-testrobotpkgarg.sh -p sot_ws/install -r
