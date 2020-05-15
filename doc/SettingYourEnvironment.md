# Setting up your environment {#d_setting_up_environment}

\section setting_up_env_var_intro Introduction

In order to make the SoT working all the environment variables in section \ref setting_up_env_variables need to be setup appropriatly.
They need to be *all* coherent.

More precisely the order of the paths in the variables specify the order to search for libraries and plugins.
They are important because a computer might have different (and often conflicting) libraries version.
They need to be consistent together.

A script to realize the setup and to be set in your .bashrc file is given in \ref setting_up_env_shell_file

\section setting_up_env_variables Important environment variables

This will set the following environment variables according to the argument.
All of the variables are important and need to be setup correctly.
As an example it we assume that you want to specify your environnement towards /opt/openrobots:

 * CMAKE_PREFIX_PATH <br>
   This variable specifies the directory where cmake is searching for libraries CMake target. It is also use by ROS to search for executables.
   For /opt/openrobots as the first directory to search it should be:

        CMAKE_PREFIX_PATH=/opt/openrobots:/whatever_was_before


 * LD_LIBRARY_PATH <br>
   Path to libraries.

        LD_LIBRARY_PATH=/opt/openrobots/lib:/opt/openrobots/lib/dynamic-graph-plugins:/whatever_was_before

 * PATH <br>
   Path of the binaries.

        PATH=/opt/openrobots/bin:/whatever_was_before

 * PKG_CONFIG_PATH <br>
   Paths to find the .pc files describing compilation flags and libraries. This is currently being deprecated for CMake export rules.

        PKG_CONFIG_PATH=/opt/openrobots/lib/pkgconfig:/whatever_was_before

 * PYTHON_PATH <br>
   Paths to find python modules. SoT install modules in site-packages directory (Python convention) instead of dist-packges (Ubuntu convention).

        PYTHON_PATH=/opt/openrobots/lib/site-package

 * ROS_PACKAGE_PATH <br>
   Path where ROS packages are installed

        ROS_PACKAGE_PATH=/opt/openrobots/share:/whatever_was_before

 * ROBOTPKG_BASE <br>
   Path where robotpkg is installed. This is not useful if you are not installing  robotpkg from source


\section setting_up_env_shell_file Shell file
To setup the environment variables you can use the script
[setup-sot.sh](https://github.com/stack-of-tasks/sot-doc/blob/master/bash/setup-sot.sh) which can be download using:

    wget https://raw.githubusercontent.com/stack-of-tasks/sot-doc/master/bash/setup-sot.sh

\section setting_up_env_conf Modification of your configuration

To use it with the binary packages installed in /opt/openrobots:

    source setup-sot.sh -p /opt/openrobots -r

Once you typed this command you can check that the previous variables have the string "/opt/openrobots".
The order set the priority.

The directory /opt/openrobots will have the highest priority with respect to all the precited variables.
This equivalent to workspace chaining in ROS.

It is recommended to handle this with aliases in your .bashrc file.
You can for instance add the following line to your .bash_aliases

    alias sop="source setup-sot.sh -p /opt/openrobots -r"
