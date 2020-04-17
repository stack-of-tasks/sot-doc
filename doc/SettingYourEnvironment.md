# Setting up your environment {#d_setting_up_environment}

\section setting_up_env_shell_file Shell file
To setup the environment variables you can use the script
[setup-opt-testrobotpkgarg.sh](https://github.com/stack-of-tasks/sot-doc/blob/master/bash/setup-opt-testrobotpkgarg.sh)

\section setting_up_env_variables Important environment variables 

This will set the following environment variables according to the argument:
 * CMAKE_PREFIX_PATH
 * LD_LIBRARY_PATH
 * PATH
 * PKG_CONFIG_PATH
 * PYTHON_PATH 
 * ROBOTPKG_BASE 
 * ROS_PACKAGE_PATH 

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
