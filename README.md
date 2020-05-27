sot-doc
=======

This repository contains the entrypoint of the LAAS stack-of-tasks implementation.
It is based on doxygen.

# Dependencies
    
This package depends on doxygen, cmake and git.

# How to contribute

Please follow the structure given in doc.
The entry point is Doxyfile.extra.in 
If you add a new file, please add the file in the entry
INPUT. 

Pictures for the documentation should be added in the directory 

    ./doc/pictures
    
as specified by the variable IMAGE_PATH

Script and configuration file for the installation and the setup of the Stack-Of-Tasks are provided in the directory bash.
Apart setup-sot.sh when you install through robotpkg.sh the files are only
used when you want to develop.

# Local generation

    mkdir build
    cd build
    cmake ..
    make doc
    
To read the produced documentation :

    firefox ./doc/doxygen-html/index.html

# 

# Updating sot-doc github webpage

The sot-doc github webpage can be update through:

    ./cmake/github/update-doxygen-doc.sh -r $PWD -b $PWD/build
    


