# Using catkin tools and vcs for the SoT {#memo_catkin_tools}

\section memo_catkin_tools_ontro Introduction
This memo explains how to handle super build (set of packages) with catkin tools.
catkin tools should not confused with catkin_make. They can be installed independently from ROS.


\section memo_catkin_tools_vcs Handling the repositories (VCS)

\subsection memo_catkin_tools_vcs_checkingout Checking out the SoT infra-structure

The set of repositories can be handled using the [vcs software]
(https://github.com/dirk-thomas/vcstool)

The repositories for the SoT can be specified in a file sot_talos.repos as follows:

    repositories:
        others/robotpkg_helpers:
            type: git
            url: https://github.com/olivier-stasse/robotpkg_helpers.git
            version: master
        src/dynamic-graph:
            type: git
            url: https://github.com/stack-of-tasks/dynamic-graph.git
            version: cmake-export
        src/dynamic-graph-python:
            type: git
            url: git@github.com:stack-of-tasks/dynamic-graph-python.git
            version: cmake-export
        src/dynamic_graph_bridge:
            type: git
            url: https://github.com/stack-of-tasks/dynamic_graph_bridge.git
            version: cmake-export
        src/dynamic_graph_bridge_msgs:
            type: git
            url: git@github.com:stack-of-tasks/dynamic_graph_bridge_msgs.git
            version: master
        src/jrl-walkgen:
            type: git
            url: git@github.com:stack-of-tasks/jrl-walkgen.git
            version: cmake-export
        src/roscontrol_sot:
            type: git
            url: git@github.com:stack-of-tasks/roscontrol_sot.git
            version: cmake-export
        src/sot-core:
            type: git
            url: https://github.com/stack-of-tasks/sot-core.git
            version: cmake-export
        src/sot-dynamic-pinocchio:
            type: git
            url: git@github.com:stack-of-tasks/sot-dynamic-pinocchio.git
            version: cmake-export
        src/sot-pattern-generator:
            type: git
            url: https://github.com/stack-of-tasks/sot-pattern-generator.git
            version: cmake-export
        src/sot-talos:
            type: git
            url: https://github.com/stack-of-tasks/sot-talos.git
            version: cmake-export
        src/sot-talos-balance:
            type: git
            url: git@gepgitlab.laas.fr:loco-3d/sot-talos-balance.git
            version: cmake-export
        src/sot-tools:
            type: git
            url: https://github.com/stack-of-tasks/sot-tools.git
            version: cmake-export
        src/sot-torque-control:
            type: git
            url: git@github.com:stack-of-tasks/sot-torque-control.git
            version: cmake-export
        src/talos_data:
            type: git
            url: git@github.com:stack-of-tasks/talos_data.git
            version: cmake-export
        src/talos_metapkg_ros_control_sot:
            type: git
            url: https://github.com/stack-of-tasks/talos_metapkg_roscontrol_sot.git
            version: pal
        src/tsid:
            type: git
            url: https://github.com/olivier-stasse/tsid.git
            version: cmake-export


To import all the repositories:

    vcs import --recursive < sot_talos.repos


You can create your own file by going in the src directory of your workspace, and then type:

    vcs export --repos > sot_talos.repos


\subsection memo_catkin_tools_vcs_status Getting the current status of the repos
In the src directory of the workspace

    vcs status -quiet


\section memo_catkin_tools_compiling Compiling and testing the packages 
\subsection memo_catkin_tools_settings Setting the cmake args
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


\subsection memo_catkin_tools_compiling Compiling
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

