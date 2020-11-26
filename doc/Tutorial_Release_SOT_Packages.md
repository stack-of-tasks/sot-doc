# Release of a SOT package on ROS {#tutorial_release_sot_packages}

\section Tutorial_introduction Introduction

This tutorial will help you to realease any new SOT packages and to maintain already released packages on ROS.

\section prerequisite

Docker need to be installed on the computer : https://docs.docker.com/engine/install/ubuntu/

To allow bloom to generate automatic pull request make sure to have a file ~/.config/bloom well initiated :
    {
        "github_user": "<your-github-username>",
        "oauth_token": "<token-you-created-for-bloom>"
    }

Log in to the GitHub account and generate a new token with “public_repo” granted.
It is situated inside the GitHub account settings under Developper settings and Personal access token

Copy this code inside the bloom file. For example:
    {
        "github_user": "Rascof",
        "oauth_token": "295a7188fbfc36f9esdsdsdqssjd21s2d1"
    }

\section first_time_release Release a package for the first time

Make sure that the .gitmodules file is clean without unmet path target. Because it can result in errors during the release.

\subsection release_repository Create a github repository for the release

For the first release you will need to create a github repository with the name : <name-of-your-package>-release
Check the Create README.md button when creating it so that the first commit is created.

Create a tracks.yaml file inside the repository with this form : https://github.com/ipab-slmc/eigenpy_catkin-release/blob/master/tracks.yaml

    tracks:
      <rosdistro>: 
        actions:
        - bloom-export-upstream :{vcs_local_uri} :{vcs_type} --tag :{release_tag} --display-uri
          :{vcs_uri} --name :{name} --output-dir :{archive_dir_path}
        - git-bloom-import-upstream :{archive_path} :{patches} --release-version :{version}
           --replace
        - git-bloom-generate -y rosrelease :{ros_distro} --source upstream -i :{release_inc}
        - git-bloom-generate -y rosdebian --prefix release/:{ros_distro} :{ros_distro}
          -i :{release_inc} --os-name ubuntu
        - git-bloom-generate -y rosdebian --prefix release/:{ros_distro} :{ros_distro}
          -i :{release_inc} --os-name debian --os-not-required
        - git-bloom-generate -y rosrpm --prefix release/:{ros_distro} :{ros_distro} -i
          :{release_inc}
        devel_branch: devel
        last_release: v<MAJOR.MINOR.PATCH>
        last_version: <MAJOR.MINOR.PATCH>
        name: <name_of_package>
        patches: null
        release_inc: '1'
        release_repo_url: https://github.com/stack-of-tasks/<name-of-package>-ros-release
        release_tag: v:{version}
        ros_distro: <rosdistro>
        vcs_type: git
        vcs_uri: https://github.com/stack-of-tasks/https://github.com/stack-of-tasks/<name-of-package>
        version: :{auto}

Make sure to update:

- <rosdistro> to the distro version you want to release to. If you want to release to several versions just copy past and change the <rosdistro>

- <MAJOR.MINOR.PATCH> to the newest version of the released package

- <name_of_package>

\subsection release Releasing you package

    # Replace <ros_distro> with the ROS distribution, e.g. melodic; noetic
    bloom-release --rosdistro <ros_distro> --track <ros_distro> <name-of-package>
or

    bloom-release --rosdistro <ros_distro> --track <ros_distro> <name-of-package> --edit

If you want to edit the tracks.yaml file (ref : https://wiki.ros.org/bloom/Tutorials/FirstTimeRelease#Releasing_Your_Packages )

There will be this error showing :

    Specified repository 'dynamic-graph-release' is not in the distribution file located at 'https://raw.githubusercontent.com/ros/rosdistro/master/melodic/distribution.yaml'
    Could not determine release repository url for repository 'dynamic-graph-release' of distro 'melodic'
    You can continue the release process by manually specifying the location of the RELEASE repository.
    To be clear this is the url of the RELEASE repository not the upstream repository.
    For release repositories on GitHub, you should provide the `https://` url which should end in `.git`.
    Here is the url for a typical release repository on GitHub: https://github.com/ros-gbp/rviz-release.git
    ==> Looking for a release of this repository in a different distribution...
    No reasonable default release repository url could be determined from previous releases.
    Release repository url [press enter to abort]:

This is ok because the package is not yet on the build farm

Enter 

    https://github.com/<name-of-your-account>/<name-of-your-package>-ros-release.git 

when asked to. Don't forget the .git at the end.

Enter your login and password for the release repository to push different branches.

At the end it should generate a pull request to add the package to the buildfarm.

\section release Release a package already on the buildfarm

\subsection release Releasing you package

Run :

     # Replace <ros_distro> with the ROS distribution, e.g. indigo; melodic
     # Replace <name-of-package> with the name used in the ROS distro file
     bloom-release <name-of-package> --rosdistro <ros_distro>

You will be asked again multiple time to enter your login and password for your release repository to push different branches.

At the end it should generate a pull request to update the package on the buildfarm.

\section prerelease Prerelease on your local machine to test for issues

\subsection prerequisite Set up your PC for a prerelease if you have already installed ROS

You need to install python3 ros buildfarm in order to generate the script you will need for the prerelease :

    sudo apt-get install python3-ros-buildfarm

\subsection prerequisite Set up your PC for a prerelease if you have not yet installed ROS

Setup of apt-get sources to include packages.ros.org. Run the following commands :

    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
    sudo apt-get update

\subsection prerelease_ros Creating a Prerelease Command

Go on this site : http://prerelease.ros.org/

Choose your ros distro 

Then select the package you want to test in the scrolling menu if your package is already on the buildfarm.

Push the next button 

After a little time the site search for dependencies to test and then you can push the generate command button

Copy/paste the code on the computer terminal

It should create 5 .sh files inside /tmp/prerelease_job/ 

Launch the prerelease with :

    ./prerelease.sh
