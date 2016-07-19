# see http://www.cmake.org/ for a documentation about CMake

cmake_minimum_required(VERSION 2.6)
project (eval_pose_human36m_bestscale_with_nn_and_assign_weights)

set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/eval_pose_human36m_bestscale_with_nn_and_assign_weights/)			# Binary file location
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})			# Exectuable file location for main and subprojects 
set(LIBRARY_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/lib)		# Library file location for main and subprojects

include_directories(${CMAKE_SOURCE_DIR})

set(PROJECT_SOURCE_DIR ${CMAKE_SOURCE_DIR}/eval_pose_human36m_bestscale_with_nn_and_assign_weights/)


############################## Adding Source Files ###################################
######################################################################################
add_executable(eval_pose_human36m_bestscale_with_nn_and_assign_weights
${PROJECT_SOURCE_DIR}/eval_pose_human36m_bestscale_with_nn_and_assign_weights.cpp  
${PROJECT_SOURCE_DIR}/../cpp/body_pose/clustering/body_clustering.cpp   
${PROJECT_SOURCE_DIR}/../cpp/body_pose/body_part_sample.cpp 
${PROJECT_SOURCE_DIR}/../cpp/body_pose/clustering/clustering_features.cpp 
${PROJECT_SOURCE_DIR}/../cpp/body_pose/body_pose_utils.cpp
${PROJECT_SOURCE_DIR}/../cpp/fashion/skin/SkinColorModelGaussian.cc
${PROJECT_SOURCE_DIR}/../cpp/fashion/skin/SkinSegmentation.cc
${PROJECT_SOURCE_DIR}/../cpp/learning/forest/forest.cpp
${PROJECT_SOURCE_DIR}/../cpp/learning/pictorial_structure/inferenz.cpp
${PROJECT_SOURCE_DIR}/../cpp/learning/pictorial_structure/learn_model_parameter.cpp
${PROJECT_SOURCE_DIR}/../cpp/learning/pictorial_structure/part.cpp
${PROJECT_SOURCE_DIR}/../cpp/learning/pictorial_structure/utils.cpp
${PROJECT_SOURCE_DIR}/../cpp/third_party/hog/tp_hog.cpp
${PROJECT_SOURCE_DIR}/../cpp/utils/file_utils.cpp
${PROJECT_SOURCE_DIR}/../cpp/utils/image_file_utils.cpp
${PROJECT_SOURCE_DIR}/../cpp/utils/serialization/serialization.cpp
${PROJECT_SOURCE_DIR}/../cpp/utils/string_utils.cpp
${PROJECT_SOURCE_DIR}/../cpp/utils/system_utils.cpp
${PROJECT_SOURCE_DIR}/../cpp/utils/threading.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/bow_extractor.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/feature_channels/feature_channel_factory.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/feature_channels/hog_extractor.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/simple_feature.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/global/gist.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/local_word_container.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/low_level/color.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/low_level/dense_surf.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/low_level/hog.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/low_level/holbp.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/low_level/lbp.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/low_level/low_level_feature_extractor.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/low_level/self_similarity.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/low_level/surf.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/low_level_features.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/features/spmbow_extractor.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/geometry_utils.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/image_utils.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/mean_shift.cpp
${PROJECT_SOURCE_DIR}/../cpp/vision/min_max_filter.cpp
${PROJECT_SOURCE_DIR}/../cpp/third_party/kmeans/kmeans.cpp
)	

target_link_libraries( eval_pose_human36m_bestscale_with_nn_and_assign_weights ${PROJECT_INCLUDE_DIR}  ${OpenCV_LIBS}  ${Boost_LIBRARIES} ${GFLAGS_LIBRARIES} ${GLOG_LIBRARIES} )		



	

