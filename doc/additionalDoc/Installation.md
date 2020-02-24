# Installation {#c_installation_detailed}

\section installation_detailed_from_binaries Installation from binary packages

We are currently providing the stack of tasks through [robotpkg](https://robotpkg.openrobots.org), 
the apt repository provided by LAAS. It is based on the NetBSD package system.

\subsection installation_robotpkg Installing binaries - Quick start

1. Setting a source.list file 
Robotpkg has two apt repository: a main repository and a work-in-progress repository:

    sudo tee /etc/apt/sources.list.d/robotpkg.list <<EOF
    deb [arch=amd64] http://robotpkg.openrobots.org/wip/packages/debian/pub $(lsb_release -cs) robotpkg
    deb [arch=amd64] http://robotpkg.openrobots.org/packages/debian/pub $(lsb_release -cs) robotpkg
    EOF


2. Register the robotpkg authentication key:

        curl http://robotpkg.openrobots.org/packages/debian/robotpkg.key | sudo apt-key add -


3. Update the list of available packages 
Please follow the instructions given <a href="http://robotpkg.openrobots.org/debian.html">here</a> to access the package repository.

    sudo apt update

4. Install the package sot-core-v3 you can use

        sudo apt install robotpkg-sot-core-v3


    To get all packages available to simulate the TALOS robot available at LAAS:

        sudo apt install robotpkg-talos-dev


\subsection installation_robotpkg_status Status of the robotpkg binaries

This NetBSD based system is currently testing the packages on a variety of UNIX distributions.
As robotpkg is providing the latest releases tested on TALOS Gazebo simulation
you can look [here](http://robotpkg.openrobots.org/rbulk/robotpkg-wip/all.html) to check the packages status.
But you have all the packages from robotpkg listed which does not make it very readable.
You can find a more readable entry in \ref status_robotpkg_binaries.

\section installation_from_source Installing from source 

\subsection installation_from_source_old_school Installing each package manually

1. Create an environment:

        mkdir -p sot_ws/src sot_ws/install sot_ws/build
        cd sot_ws/src
    
2. For a package (let us say dynamic-graph):

        git clone git@github.com:stack-of-tasks/dynamic-graph.git --recursive
        cd ../build
        mkdir dynamic-graph
        cmake  -DCMAKE_INSTALL_PREFIX=$PWD/../../install ../../src/dynamic-graph
        
3. To build (with 8 threads):
   
       make -j 8

4. To install:
    
        make install
        
5. To run unit tests:
   
        make test
        
6. To make documentation:

        make doc
        
\subsection installation_from_source_catkin_build Installing from catkin (for development/experimental)

The complete and detailed information can be found in \ref memo_catkin_tools

\subsection installation_from_source_robotpkg Installing from robotpkg (to prepare an environment)

The source installation can be realized through robotpkg but be aware that this not advised for development.

Please follow the instructions given [here](http://robotpkg.openrobots.org/install.html) to get the package repositories.

You will also have to install the wip (work in progress) part of robotpkg. The installation procedure is described
[here](http://robotpkg.openrobots.org/robotpkg-wip.html).

To compile and install the package <b>sot-core-v3</b> then you can type:

    cd robotpkg/wip/sot-core-v3
    make install

# Setting up your environment {#d_setting_up_environment}

To setup the environment variables you can use the following script [setup-opt-testrobotpkgarg.sh](https://github.com/stack-of-tasks/sot-doc/bash/setup-opt-testrobotpkgarg.sh)

