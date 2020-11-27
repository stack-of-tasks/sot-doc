# Release of a SoT package on ROS {#tutorial_release_sot_packages}

\section Tutorial_introduction Introduction

This tutorial will help to realease any new SoT package and to maintain already released package on ROS.

Before any release you should test the prerelease of the package to see if there is no errors remaining.

\section prerelease Prerelease on the local machine to test for issues

\subsection Prerequisite 

Docker need to be installed on the computer (ref.: https://docs.docker.com/engine/install/ubuntu/ ) :

    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io

Test if the docker engine is correctly installed:

    sudo docker run hello-world


\subsubsection ROS Set up your PC for a prerelease if ROS is already installed

Install python3 ros buildfarm in order to generate the script needed for the prerelease :

    sudo apt-get install python3-ros-buildfarm

\subsubsection not_ROS Set up the PC for a prerelease if ROS is not installed yet

Setup of apt-get sources to include packages.ros.org. Run the following commands :

    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
    sudo apt-get update

\subsection prerelease_ros Creating a Prerelease Command

Go on this site : http://prerelease.ros.org/

Choose your ros distro 

Then select the package you want to test in the scrolling menu if your package is already on the buildfarm. If not push the red cross and add a custom repository.

Push the next button.

After a little time the site search for dependencies to test and then you can push the generate command button.

Copy/paste the code on the computer terminal.

It should create 5 .sh files inside /tmp/prerelease_job/ 

Launch the prerelease with :

    ./prerelease.sh

If everything went well you will arrive until the 11 job where the test should be done. We are not using those catkin test for the SoT packages. You should have the prerelease finishing with :

    ...

    Build step 10

    Build step 11
    # BEGIN SECTION: Create collated test stats dir
    # END SECTION


    Test results of underlay workspace

    Invoking: catkin_test_results /tmp/prerelease_job/ws/test_results --all
    Test results directory "/tmp/prerelease_job/ws/test_results" does not exist


    Skipping empty overlay workspace

If not search what is wrong with the package. It could be :

- Missing dependencies
- Compilation error
- Connection error

\subsection prerelease_error Possible errors during the prerelease

Error :

    Permission denied to access config.json

Solution :

    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R

Error :

    permission denied for the creation of .ccmake/tmp

Solution :

    sudo chown -R $USER:$USER /home/$USER/.ccache

If a new issue is met : https://docs.docker.com/

\subsection clean_docker Clean docker

After a prerelease there are still generated files left on the computer and it will soon take too much space.

Enter : 

    docker system prune -a 

To remove all the unused images, containers, volume and network of docker.

\section first_time_release Release a package for the first time

\subsection prerequisite_intro Prerequisite

Bloom need to be installed (ref.: http://ros-infrastructure.github.io/bloom/ ) :

    sudo apt-get install python-bloom

To allow bloom to generate automatic pull request make sure to have a file ~/.config/bloom well initiated :

    {
        "github_user": "<github-username>",
        "oauth_token": "<token-you-created-for-bloom>"
    }

Log in to the GitHub account and generate a new token with “public_repo” granted.
It is situated inside the GitHub account settings under Developper settings and Personal access token

Copy this code inside the bloom file. For example:

    {
        "github_user": "Rascof",
        "oauth_token": "295a7188fbfc36f9esdsdsdqssjd21s2d1"
    }

Make sure that the .gitmodules file is clean without unmet path target. Because it can result in errors during the release.

\subsection release_repository Create a github repository for the release

For the first release, create a github repository with the name : <package-name>-ros-release

Check the Create README.md button when creating it so that the first commit is created.

Create a tracks.yaml file inside the repository like this (example at : https://github.com/ipab-slmc/eigenpy_catkin-release/blob/master/tracks.yaml) :

    tracks:
      <ros_distro>: 
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
        name: <package_name>
        patches: null
        release_inc: '1'
        release_repo_url: https://github.com/stack-of-tasks/<package-name>-ros-release
        release_tag: v:{version}
        ros_distro: <ros_distro>
        vcs_type: git
        vcs_uri: https://github.com/stack-of-tasks/https://github.com/stack-of-tasks/<package-name>
        version: :{auto}

Make sure to update:

- <ros_distro> to the distro version wanted. To release to several versions just copy past and change the <ros_distro>

- <MAJOR.MINOR.PATCH> to the newest version of the released package

- <package-name>

\subsection release Releasing the package for the first time

    # Replace <ros_distro> with the ROS distribution, e.g. melodic; noetic
    # Replace <package-name> with the name used in the ROS distro file
    bloom-release --rosdistro <ros_distro> --track <ros_distro> <package-name>
or

    bloom-release --rosdistro <ros_distro> --track <ros_distro> <package-name> --edit

To edit the tracks.yaml file (ref : https://wiki.ros.org/bloom/Tutorials/FirstTimeRelease#Releasing_Your_Packages )

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

Enter :

    https://github.com/<name-of-account>/<package-name>-ros-release.git 

Don't forget the .git at the end.

Enter the login and password for the release repository to push different branches.

At the end it should generate a pull request to add the package to the buildfarm.

If not, make sure to have a ~/.config/bloom well initiated or follow this tutorial if you have two-factor authentication enabled : http://wiki.ros.org/bloom/Tutorials/GithubManualAuthorization

\section maintained Maintain packages already on the buildfarm

Run :

     # Replace <ros_distro> with the ROS distribution, e.g. melodic; noetic
     # Replace <package-name> with the name used in the ROS distro file
     bloom-release <package-name> --rosdistro <ros_distro>

Enter the login and password two times for the release repository to push different branches.

At the end it should generate a pull request on GitHub to update the version on the GitHub repository of ROS : https://github.com/ros/rosdistro 

If not make sure to have a ~/.config/bloom well initiated or follow this tutorial if you have two-factor authentication enabled : http://wiki.ros.org/bloom/Tutorials/GithubManualAuthorization

\section patch ROS Patch

This section shows how to manage patches. If there is an installation rule specific to ROS you can use patches. Patches are a rule to modify the source code only when installed with ROS.
For more insight : http://wiki.ros.org/bloom/Tutorials/ReleaseThirdParty from section 2.4 to 2.6

\subsection patch1 Create a patch

Clone the ros release repository on the computer

    git clone https://github.com/<name-of-account>/<package-name>-ros-release
    cd <package-name>-ros-release

Enter the branch of the ros release repository where the source code need to be changed
 
    git checkout release/<ros_distro>/<package-name>

Make the modifications 

    git add .
    git commit -m "<Comments>"
    git-bloom-patch export
    git push
    git-bloom-release <ros_distro>

Finally, procceed with a realease on ROS.

\subsection patch2 Remove patches

There is a way to remove all patches (I did not find a way to remove only one patch)

Clone the ros release repository on the computer

    git clone https://github.com/<name-of-account>/<package-name>-ros-release
    cd <package-name>-ros-release

Enter the branch of the ros release repository where the source code need to be changed
 
    git checkout release/<ros_distro>/<package-name>

Remove the patches

    git-bloom-patch remove
    git push --all
    git-bloom-release <ros_distro>

Finally, procceed with a realease on ROS.

\subsection patch3 Porting patches between ros version

Port patches from one distro to another

    git checkout patches/release/<new_ros_distro>/<package-name>
    git ls-tree --name-only -r patches/release/<former_ros_distro>/<package-name> | grep '\.patch' | xargs -I {} sh -c 'git show patches/release/<former_ros_distro>/<package-name>:"$1" > "$1"' -- {}
    git add .
    git commit -m "Importing patches from <former_ros_distro> to <new_ros_distro>"
    git checkout release/<new_ros_distro>/<package-name>
    git-bloom-patch import
    git push --all
    git push --tags

Finally, procceed with a realease on ROS

\section check Check if the build succeded on the build farm

When the release is done and the pull request is accepted by ROS developpers the package will automatically be build on the ROS build farm with Jenkins.

The maintainer of the GitHub repository specified inside the package.xml will receive an e-mail with the success or failure of the build.

There is a need to check if all jobs succeded on the site where the ROS build farm is held : http://build.ros.org/

Search for the name of the package and check every job.

The first letter of the jobs is the ROS distro version :

- M for melodic
- N for noetic

\section TestingRepository Testing Repository

When the package is finally released it is not yet on the official build farm. It is in a soaking area where you can test your packages before it is released on the public ROS build farm. For more insight : http://wiki.ros.org/action/show/TestingRepository?action=show&redirect=ShadowRepository

To change to ros testing :

Change ros into ros-testing inside this file /etc/apt/sources.list.d/ros-latest.list

Like this :

    deb http://packages.ros.org/ros-testing/ubuntu bionic main

Then :

    sudo apt-get update
    sudo apt-get install ros-<ros_distro>-<package-name>

To go back to the official ROS build farm change back to ros on /etc/apt/sources.list.d/ros-latest.list

Then :

    sudo apt-get update
    sudo apt-get dist-upgrade

