# Setting up your environment {#d_setting_up_environment}

\section setting_up_env_shell_file Shell file
To setup the environment variables you can use the script
[setup-opt-testrobotpkgarg.sh](https://github.com/stack-of-tasks/sot-doc/blob/master/bash/setup-opt-testrobotpkgarg.sh)

\section setting_up_env_variables Important environment variables

This will set the following environment variables according to the argument:

 * CMAKE_PREFIX_PATH <br>
   This variable specifies the directory where cmake is searching for libraries CMake target. It is also use by ROS to search for executables.

 * LD_LIBRARY_PATH <br>
   Path to libraries.

 * PATH <br>
   Path of the binaries.

 * PKG_CONFIG_PATH <br>
   Paths to find the .pc files describing compilation flags and libraries. This is currently being deprecated for CMake export rules.

 * PYTHON_PATH <br>
   Paths to find python modules. SoT install modules in site-packages directory (Python convention) instead of dist-packges (Ubuntu convention).

 * ROBOTPKG_BASE <br>
   Path where robotpkg is installed.

 * ROS_PACKAGE_PATH <br>
   Path where ROS packages are installed

\section setting_up_env_conf Modification of your configuration

To use it with the binary packages installed in /opt/openrobots:

    source setup-opt-testrobotpkgarg.sh -p /opt/openrobots -r

Once you typed this command you can check that the previous variables have the string "/opt/openrobots".
The order set the priority.

The directory /opt/openrobots will have the highest priority with respect to all the precited variables.
This equivalent to workspace chaining in ROS.

It is recommended to handle this with aliases in your .bashrc file.
You can for instance add the following line to your .bash_aliases

    alias sop="source setup-opt-testrobotpkgarg.sh -p /opt/openrobots -r"
