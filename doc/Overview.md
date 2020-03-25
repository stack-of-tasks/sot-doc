\page page_overview Overview

\section OverviewIntro What is the Stack-Of-Tasks ?

The goal of the Stack-of-Tasks (SoT) is to provide a SDK in order to:
 * Write control problem for complex robots such as humanoid robots
 * Test them quickly using geometric settings (rviz, gepetto-viewer), dynamic simulators (ODE,Bullet), system simulator (Gazebo)
 * Deploy them in real robots (TALOS, HRP-2)
Depending on your target you might not be interested in using the full set of software we are providing. But the main goal of this SDK is to consider a robot model 
\\( RM \\), its current state \\( x \\) and computes a control vector \\(u \\) to make the robot performs actions.

All our controllers are defined as optimization problems. We are using either off-the-shelf solvers or our own solvers, depending of the targeted applications. The free variables are the control vector \\( u \\) to apply to the system. They are constraints which can be of several kinds: the mechanical constraints of the system with the environment, the behavior that we want the robot to follow. A short introduction on how those two constraints can be mathematically formulated can be found 
in \ref controllers_information . We strongly recommend that you read it if you do not have a good grasp of robot control.

\section InstallIntro Installation

It is recommended to install the Stack-Of-Tasks from binaries. This is strongly recommended if you are working on one of the robot currently supported: TALOS or Tiago.
More information are given in the \ref installation_detailed page.

\subsection subsecInstallIntroBin Installing from binaries

We recommend to install from binaries using the robotpkg apt repository. It is planned to have some SoT core packages integrated in ROS Melodic around June 2020.
More information are available in the \ref installation_detailed_from_binaries section.

\subsection subsecInstallIntroSrc Installing from sources

This installation provides more flexibility but needs some good computer science skills.
More information are available in the \ref installation_from_source section.

\section OrganizationIntro Organization

The SoT SDK is organized in packages in the following modules:
 * Core algorithmic libraries: They all can be used *WITHOUT* the other modules
   * pinocchio: A fast and flexible rigid body dynamic library implementing proper algebraic computation of mechanical quantities.
   * tsid: A Task Space Inverse Dynamics library.
   * jrl-walkgen: A library targed to make humanoid robot walks.
 * Modules to handle a dynamic graph of computational entities:
   * dynamic-graph: A C++ graph library allowing to build a graph of computational entities. This is not a middleware, it handles time dependencies.
   * dynamic-graph-python: Python bindings to manage the dynamic-graph structure. Plus a C embedded python interpreter which can be used together with the C++ library for on-line graph modification
 * Solvers to generate control laws:
   * sot-core: Kinematics based solver. It is strongly based on the stack-of-taks paradigm and exposed several objects. This is has tested on several occasions and platforms and is allowing fast prototyping of robot motions.
   * sot-dynamic-pinocchio: A sot-wrapper around pinocchio. This library exposes all the robot quantities (end-effectors position, CoM, mass matrix)
   * sot-torque-control: A sot-wrapper around TSID. 
   * sot-pattern-generator: A sot-wrapper around jrl-walkgen. This library provides feet, waist, ZMP and CoM trajectories.

