sot-doc
=======

This repository contains the entrypoint of the LAAS stack-of-tasks implementation.
It is based on doxygen.

# Local generation

    mkdir build
    cd build
    cmake ..
    make doc
    
To read the produced documentation :

    firefox ./doc/doxygen-html/index.html
    
# Updating sot-doc github webpage

The sot-doc github webpage can be update through:

    ./cmake/github/update-doxygen-doc.sh -r $PWD -b $PWD/build
    


