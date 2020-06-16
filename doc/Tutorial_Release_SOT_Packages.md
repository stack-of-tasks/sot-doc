# Release of a SOT package {#tutorial_release_sot_packages}

/section Tutorial_introduction Introduction

This tutorial will help you to realease any new SOT packages and to maintain already released packages.

/section first_time_release Release a package for the first time

Make sure that the .gitmodules file is clean without unmet path target. Because it can result in errors during the release.

Clone your upstream repository locally on the branch were you developed your code

git clone --recursive-submodules --branch=<your_branch> https://github.com/<name-of-your-account>/<name-of-your-package>
cd <name-of-your-package>

/subsection changelog Generate Changelog (Optional)

If you want you can generate a changelog to keep track of the changes :

catkin_generate_changelog --all

git add .
git commit -am "Update Changelog"

/subsection prepare_release Preparation for the release 

Then run :

catkin_prepare_release --tag-prefix=v

Enter your github login and password when asked to (If you have a two factor authentification please refer to : http://wiki.ros.org/bloom/Tutorials/GithubManualAuthorization )

/subsection release_repository Create a github repository for the release

For the first release you will need to create a github repository with the name : <name-of-your-package>-release
Check the Create README.md button when creating it so that the first commit is created.

Clone this github repository on your local machine :

cd #go to your home directory
git clone https://github.com/<name-of-your-account>/<name-of-your-package>-release

Then create a tracks.yaml file inside the repository with this form : https://github.com/ipab-slmc/eigenpy_catkin-release/blob/master/tracks.yaml

Then push it into the github repository.

/subsection release Releasing you package

Go where you cloned your release repository then run

cd
# Replace <ros_distro> with the ROS distribution, e.g. indigo; melodic
bloom-release --rosdistro <ros_distro> --track <ros_distro> <name-of-your-package-release>
or
bloom-release --rosdistro <ros_distro> --track <ros_distro> <name-of-your-package-release> --edit
If you want to edit the tracks.yaml file (ref : https://wiki.ros.org/bloom/Tutorials/FirstTimeRelease#Releasing_Your_Packages )

Normally you will have this error : 
```
Specified repository 'dynamic-graph-release' is not in the distribution file located at 'https://raw.githubusercontent.com/ros/rosdistro/master/melodic/distribution.yaml'
Could not determine release repository url for repository 'dynamic-graph-release' of distro 'melodic'
You can continue the release process by manually specifying the location of the RELEASE repository.
To be clear this is the url of the RELEASE repository not the upstream repository.
For release repositories on GitHub, you should provide the `https://` url which should end in `.git`.
Here is the url for a typical release repository on GitHub: https://github.com/ros-gbp/rviz-release.git
==> Looking for a release of this repository in a different distribution...
No reasonable default release repository url could be determined from previous releases.
Release repository url [press enter to abort]:
```

This is ok because your package is not yet on the buildfarm

You will have to enter https://github.com/<name-of-your-account>/<name-of-your-package>-release.git when asked to. Don't forget the .git at the end.

You will be asked again multiple time to enter your login and password for your release repository to push different branches.

At the end it should generate a pull request to add your package to the buildfarm.

/section release Release a package already on the buildfarm

Clone your upstream repository on the branch were you developed your code

git clone --recursive-submodules --branch=<your_branch> https://github.com/<name-of-your-account>/<name-of-your-package>
cd <name-of-your-package>

/subsection changelog Generate Changelog (Optional)

If you want you can generate a changelog to keep track of the changes :

catkin_generate_changelog --all

git commit -am "Update Changelog"

/subsection prepare_release Preparation for the release 

Then run :

catkin_prepare_release --tag-prefix=v

Enter your github login and password when asked to (If you have a two factor authentification please refer to : http://wiki.ros.org/bloom/Tutorials/GithubManualAuthorization )

/subsection release Releasing you package

Run :

# Replace <ros_distro> with the ROS distribution, e.g. indigo; melodic
# Replace <name-of-your-package> with the name used in the ROS distro file
bloom-release <name-of-your-package> --rosdistro <ros_distro>

You will be asked again multiple time to enter your login and password for your release repository to push different branches.

At the end it should generate a pull request to update your package on the buildfarm.

/section prerelease Prerelease on your local machine to test for issues

/subsection prerequisite Set up your PC for a prerelease if you have already installed ROS

You need to install python3 ros buildfarm in order to generate the script you will need for the prerelease :

sudo apt-get install python3-ros-buildfarm

/subsection prerequisite Set up your PC for a prerelease if you have not yet installed ROS

You will need to setup apt-get sources to include packages.ros.org. Run the following commands :

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get update

/subsection prerelease_ros Creating a Prerelease Command

You will need to go on this site : http://prerelease.ros.org/

Choose your ros distro 

Then select the package you want to test in the scrolling menu if your package is already on the buildfarm.

Push the next button 

After a little time the site search for dependencies to test and then you can push the generate command button

Copy/paste the code on your terminal

It should create 5 .sh files in your /tmp/prerelease_job/ 

To create the prerelease run :

./prerelease.sh




