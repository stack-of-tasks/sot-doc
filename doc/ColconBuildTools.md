# Using colcon tools and vcs for the SoT {#memo_colcon_tools}

\section memo_colcon_tools_intro Introduction

This memo explains how to create and handle a super build (set of packages) workspace of the SoT with [colcon](https://colcon.readthedocs.io/en/released/) tools.
Colcon can be installed independently from ROS using pip.

As explained in \ref memo_colcon_tools_intro there is several solutions to install a source base environment.

\subsection memo_colcon_tools_quick_start Quick start

\subsubsection memo_colcon_tools_quick_start_depends Install third party dependencies of the SoT packages

To install the necessary SoT software third party dependencies in '''/path_to_target_dir``` you can simply try:

    wget -O install-dep-thru-rpkg.sh https://raw.githubusercontent.com/stack-of-tasks/sot-doc/master/bash/install-dep-thru-rpkg.sh
    chmod +x ./install-dep-thru-rpkg.sh
    ./install-dep-thru-rpkg.sh -p /path_to_target_dir -s /path_to_robotpkg_src

This will donwload, set, compile and install the binairies in ```/path_to_target_dir``` and store the sources in ```/path_to_robotpkg_src```.
It is heavily based on the tool [robotpkg](https://robotpkg.openrobots.org)

Other options to install the source dependencies are given in \ref memo_preparing_environment.

\subsubsection memo_colcon_tools_quick_start_setnv Setup your environment

    source setup-sot.sh -p /path_to_target_dir -r
    source setup-sot.sh -p /path_to_sot_ws/install -r

\subsubsection memo_colcon_tools_quick_create_ws Create your workspace

Once this is done, to create your SoT workspace using the file [sot_talos.repos](https://github.com/stack-of-tasks/sot-doc/blob/master/config/sot_talos.repos):

    wget -O install-sot-catkin-ws.sh https://raw.githubusercontent.com/stack-of-tasks/sot-doc/master/bash/install-sot-catkin-ws.sh
    chmod +x ./install-sot-catkin-ws.sh
    ./install-sot-catkin-ws.sh -p /path_to_sot_ws

\subsection memto_catkin_tools_quick_start_explanations Quick start explanations

The previous script is doing the following steps:

    mkdir -p /path_to_sot_ws
    cd /path_to_sot_ws
    wget -O sot_talos.repos https://raw.githubusercontent.com/stack-of-tasks/sot-doc/master/config/sot_talos.repos
    vcs import --recursive < sot_talos.repos
    # configure your catkin environment

To build everything you can simply type:

    colcon build --merge-install

The cmake arguments are explained in more details in \ref memo_colcon_tools_compiling

\section memo_colcon_tools_vcs Handling the repositories (VCS)

This section is already described 

\section memo_colcon_tools_compiling Compiling and testing the packages (catkin)

\subsection memo_colcon_tools_compiling_settings Setting the cmake args
For instance we want to force the system to be in debug mode
and to set some variables we can use the following command:

    cd /path_to_sot_ws
    colcon build --merge-install --packages-select sot-dynamic-pinocchio --cmake-args ' -DPYTHON_EXECUTABLE=/usr/local/opt/python@3.8/bin/python3' ' -DCMAKE_BUILD_TYPE=RELEASE'  ' -DCMAKE_CXX_COMPILER=/usr/bin/c++' ' -DCMAKE_CXX_STANDARD=14'

It forces the package sot-dynamic-pinocchio to be installed in the install folder,
forces  the CMake package to be compiled in RELEASE mode,
and the python executable is

    /usr/local/opt/python@3.8/bin/python3

\subsection memo_colcon_tools_compiling_compiling Compiling

\subsubsection memo_colcon_tools_compiling_all Compiling everything

    colcon build --merge-install


\subsubsection memo_colcon_tools_compiling_a_pkg Compiling a specific package with its dependencies
For instance the following command is compiling the dynamic-graph-python
package:


    colcon build --merge-install --packages-up-to dynamic-graph-python


\subsubsection memo_colcon_tools_compiling_a_pkg_nodeps Compiling a specific package without its dependencies
For instance the following command is compiling the dynamic-graph-python
package:


    colcon build --merge-install --packages-select dynamic-graph-python

\subsubsection memo_colcon_tools_compiling_a_pkg_doc Generating the documentation
For instance the following command is generating the documentation for the sot-core
package:

    colcon build --merge-install --packages-select sot-core  --make-args doc

\subsection memo_colcon_tools_clean_all Clean all the build part

    rm -rf ./build

\subsection memo_colcon_tools_run_tests Running tests
Example running the test programs of the package dynamic-graph-python in the workspace root directory:


    colcon test --packages-select dynamic-graph-python

Note: make sure that the install directory is specified in the environment variables LD_LIBRARY_PATH and PYTHONPATH for instance.
By default *all* dependent packages will also run the tests. To prevent this it is highly recommended to use:


    colcon test --packages-select dynamic-graph-python


\subsection memo_colcon_tools_compute_coverage Computing coverage

You need to add to the CXX_FLAGS and the LD_FLAGS the value --coverage:


    colcon build --cmake-args -DCMAKE_CXX_FLAGS="--coverage" -DCMAKE_LD_FLAGS="--coverage"


Then run the test:

    colcon test dynamic-graph-python


And in the workspace root directory you need to run:

    gcovr -r . --html --html-details -o ./logs/coverage/index.html


To get the output of the coverage:

    firefox ./logs/coverage/index.html

