# Release of a SOT package

/section Tutorial_introduction Introduction

This tutorial will help you to realease any new SOT packages and to maintain already released packages.

/section first_time_release Release a package for the first time

For the first release you will need to create a github repository with the name : <name-of-your-package>-release
Check the Create Read.me button when creating it so that the first commit is created.

Clone this github repository on your local machine :

git clone https://github.com/......

Then create a tracks.yaml file inside the repository with this form :

tracks:
  kinetic:
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
    devel_branch: master
    last_release: v2.4.5
    last_version: 2.4.5
    name: upstream
    patches: null
    release_inc: '1'
    release_repo_url: git@github.com:ipab-slmc/pinocchio_catkin-release.git
    release_tag: :{ask}
    ros_distro: kinetic
    vcs_type: git
    vcs_uri: https://github.com/stack-of-tasks/pinocchio.git
    version: :{auto}
  melodic:
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
    devel_branch: master
    last_release: v2.4.5
    last_version: 2.4.5
    name: upstream
    patches: null
    release_inc: '1'
    release_repo_url: git@github.com:ipab-slmc/pinocchio_catkin-release.git
    release_tag: v:{version}
    ros_distro: melodic
    vcs_type: git
    vcs_uri: https://github.com/stack-of-tasks/pinocchio.git
    version: :{auto}

Then push it into the github repository.
