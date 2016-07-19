# see http://www.cmake.org/ for a documentation about CMake

cmake_minimum_required(VERSION 2.6)
project (global)



######################### Set Module Path ######################### 
############ Path where FindLib.cmake files are located ###########
###################################################################
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

####################### CUSTOM_LIBRARY_PATH ####################### 
#########  Adjust this path if local libraries are used  ##########
###################################################################
set(CUSTOM_LIBRARY_PATH "/media/data/doering/Libraries/")

set(CMAKE_CXX_FLAGS "-std=c++0x")				# New C11


#set(CMAKE_BUILD_TYPE debug)					# choose if you want to compile with or without debugging flags,
set(CMAKE_BUILD_TYPE release)					# uncomment only one of the following two commands at a time

################################## Find required packages ############################
########################### Loading the required packages ############################ 
######################################################################################

##### OpenCV
find_package( OpenCV REQUIRED )
##### Boost
SET(Boost_USE_STATIC_LIBS OFF) 
SET(Boost_USE_MULTITHREADED ON)  
set(Boost_USE_STATIC_RUNTIME OFF) 
find_package(Boost 1.55.0 COMPONENTS date_time iostreams program_options regex serialization system thread filesystem REQUIRED)

####################################### GFlags #######################################  
find_package(GFlags REQUIRED)

######################################## GLOG ######################################## 
find_package(GLOG REQUIRED)

############################ Include Required Directories ############################ 			
include_directories(${PROJECT_SOURCE_DIR})
include_directories(${OpenCV_INCLUDE_DIRS})
include_directories(${Boost_INCLUDE_DIR})
include_directories(${GLOG_INCLUDE_DIRS})
include_directories(${GFLAGS_INCLUDE_DIRS})


add_subdirectory(eval_pose_human36m_multiscale)
add_subdirectory(eval_pose_human36m_bestscale_with_nn_and_assign_weights)

