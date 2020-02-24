CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

# Setup project properties
SET(PROJECT_ORG stack-of-tasks)
SET(PROJECT_NAME sot-doc)
SET(PROJECT_DESCRIPTION "Documentation entry point for the Stack-Of-Tasks")
SET(PROJECT_URL "http://github.com/${PROJECT_ORG}/${PROJECT_NAME}")

INCLUDE(cmake/base.cmake)

# Allows math in mathjax.
SET(DOXYGEN_USE_MATHJAX YES)

# Specify the project.
COMPUTE_PROJECT_ARGS(PROJECT_ARGS LANGUAGES CXX)
PROJECT(${PROJECT_NAME} ${PROJECT_ARGS})
