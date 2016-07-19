/*
 * eval_utils.cpp
 *
 *  Created on: Apr 24, 2013
 *      Author: gandrada
 */

namespace learning {
namespace forest {
namespace utils {

using learning::common::Image;
using vision::features::feature_channels::FeatureChannelFactory;

template <typename T>
void evaluate_binary_problem(
    const Forest<T>& forest,
		const std::vector<T>& sample,
		std::vector<float>* responses) {
	typedef typename T::Leaf L;

	for(int i=0; i < sample.size(); i++) {
		std::vector<L*> leafs;
		forest.evaluate(&sample[i], leafs);

		float foreground = 0;
		for(int j=0; j < leafs.size(); j++) {
			foreground += leafs[j]->forground;
		}
		responses->push_back(foreground/leafs.size());
	}
}

template <typename T>
void get_voting_map(
		const Image& sample,
		const Forest<T>& forest,
		cv::Mat& voting_map,
		const cv::Rect roi,
		int step_size,
		bool blur,
		bool normalize,
		cv::Rect sliding_window) {
	typedef typename T::Leaf L;
	voting_map = cv::Mat::zeros(roi.height, roi.width,
															cv::DataType<float>::type);

  if(sliding_window.height < 1 || sliding_window.width < 1) {
    ForestParam param = forest.getParam();
    sliding_window = cv::Rect(0,0, param.patch_width, param.patch_height);
  }
  int patch_width = sliding_window.width;
  int patch_height = sliding_window.height;

	for (int x = roi.x; x < roi.x + roi.width - patch_width; x += step_size) {
		for (int y = roi.y; y < roi.y + roi.height - patch_height; y += step_size) {
      cv::Rect patch_box(x, y, patch_width, patch_height);
      T s(&sample, patch_box);
      std::vector<L*> leafs;
      forest.evaluate(&s, leafs);


      cv::Point_<int> center(x+patch_width/2, y+patch_height/2);
      for(int i=0; i < leafs.size();i++) {
        float foreground = leafs[i]->forground;
        cv::Point_<int> vote = center + leafs[i]->offset;
				if (foreground > 0 && vote.x > 0 && vote.y > 0 &&
						vote.x < roi.width && vote.y < roi.height ) {
          voting_map.at<float> (vote) += foreground/leafs.size();
        }
      }
    }
  }

  if(blur){
    //cv::blur(voting_map, voting_map, cv::Size(3,3));
    int x = sliding_window.width/2 - 1; int y = sliding_window.height/2 - 1;
     int width = voting_map.cols - sliding_window.width + 1;
     int height = voting_map.rows - sliding_window.height + 1;
     cv::Rect bbox(x,y,width, height);
    cv::Mat roi = voting_map(bbox);
    cv::GaussianBlur(roi, roi, cv::Size(), 3, 3, cv::BORDER_REFLECT);
  }
}

template <typename T>
void get_conditional_voting_map(
		const Image& sample,
		const Forest<T>& forest,
		cv::Mat& voting_map,
		const cv::Rect roi,
		int step_size,
		bool blur,
		bool normalize,
		cv::Rect sliding_window,
		std::vector<double> cond_reg_weights) {
	typedef typename T::Leaf L;
  int global_attr_label = sample.get_global_attr_label();

  if(global_attr_label < 0){
    get_voting_map(sample, forest, voting_map, roi, step_size,blur, normalize, sliding_window);
    return;
  }
  else{
    voting_map = cv::Mat::zeros(roi.height, roi.width,
															cv::DataType<float>::type);
    if(sliding_window.height < 1 || sliding_window.width < 1) {
      ForestParam param = forest.getParam();
      sliding_window = cv::Rect(0,0, param.patch_width, param.patch_height);
    }
    int patch_width = sliding_window.width;
    int patch_height = sliding_window.height;
    for (int x = roi.x; x < roi.x + roi.width - patch_width; x += step_size) {
      for (int y = roi.y; y < roi.y + roi.height - patch_height; y += step_size) {
        cv::Rect patch_box(x, y, patch_width, patch_height);
        T s(&sample, patch_box);
        std::vector<L*> leafs;
        forest.evaluate(&s, leafs);

        cv::Point_<int> center(x+patch_width/2, y+patch_height/2);
        for(int i=0; i < leafs.size();i++) {
          float foreground = leafs[i]->forground;
          std::vector<cv::Point>& attr_offsets = leafs[i]->global_attr_offsets;
          std::vector<int>& attr_hist = leafs[i]->global_attr_hist;

          CHECK_EQ(attr_hist.size(), attr_offsets.size());

          //TODO: fix the hard coding of number of attribute classes
          for(unsigned int j=0; j<attr_offsets.size(); j++){
            cv::Point_<int> vote = center + attr_offsets[j];
            if (foreground > 0 && vote.x > 0 && vote.y > 0 &&
             vote.x < roi.width && vote.y < roi.height ) {
              float val = (static_cast<float>(attr_hist[j])/leafs[i]->num_samples)/leafs.size();

              if(cond_reg_weights.size() == 0){
                if(j == global_attr_label){
                  voting_map.at<float> (vote) += 1*val;
                }
                else{
                  voting_map.at<float> (vote) += 0*val;
                }
              }
              else{
                CHECK_GE(cond_reg_weights.size(), attr_hist.size());
                voting_map.at<float> (vote) += cond_reg_weights[j] * val;
              }
            }
          }
        }
      }
    }
  }
  if(blur)
      cv::GaussianBlur(voting_map, voting_map, cv::Size(), 3, 3);
}

// returns a voting map for each value of global attribute variable
template <typename T>
void get_attr_wise_conditional_voting_map(
		const Image& sample,
		const Forest<T>& forest,
		std::vector<cv::Mat_<float> >& voting_maps,
		const cv::Rect roi,
		int step_size,
		bool blur,
		bool normalize,
		cv::Rect sliding_window,
		std::vector<double> cond_reg_weights) {


    typedef typename T::Leaf L;
    CHECK(voting_maps.size());
    for(unsigned int i=0; i<voting_maps.size(); i++){
      voting_maps[i] = cv::Mat::zeros(roi.height, roi.width,
                                    cv::DataType<float>::type);
    }
    if(sliding_window.height < 1 || sliding_window.width < 1) {
      ForestParam param = forest.getParam();
      sliding_window = cv::Rect(0,0, param.patch_width, param.patch_height);
    }
    int patch_width = sliding_window.width;
    int patch_height = sliding_window.height;
    for (int x = roi.x; x < roi.x + roi.width - patch_width; x += step_size) {
      for (int y = roi.y; y < roi.y + roi.height - patch_height; y += step_size) {
        cv::Rect patch_box(x, y, patch_width, patch_height);
        T s(&sample, patch_box);
        std::vector<L*> leafs;
        forest.evaluate(&s, leafs);

        cv::Point_<int> center(x+patch_width/2, y+patch_height/2);
        for(int i=0; i < leafs.size();i++) {
          float foreground = leafs[i]->forground;
          std::vector<cv::Point>& attr_offsets = leafs[i]->global_attr_offsets;
          std::vector<int>& attr_hist = leafs[i]->global_attr_hist;
          //LOG(INFO)<<::utils::VectorToString(attr_hist);
          CHECK_EQ(attr_hist.size(), attr_offsets.size());
          CHECK_LE(attr_offsets.size(), voting_maps.size());

          for(unsigned int j=0; j<attr_offsets.size(); j++){
            cv::Point_<int> vote = center + attr_offsets[j];
            float val = (static_cast<float>(attr_hist[j])/leafs[i]->num_samples)/leafs.size();
            if (foreground > 0 && vote.x > 0 && vote.y > 0 &&
             vote.x < roi.width && vote.y < roi.height ) {
                voting_maps[j].at<float> (vote) += val;
            }
          }
        }
      }
    }
    if(blur){
    for(unsigned int i=0; i<voting_maps.size(); i++){
      cv::blur(voting_maps[i], voting_maps[i], cv::Size(3,3));
      //cv::GaussianBlur(voting_maps[i], voting_maps[i], cv::Size(), 3, 3);
    }
  }
}

template <typename T>
void get_forground_map(
		const Image& sample,
		const Forest<T>& forest,
		cv::Mat& foreground_map,
		const cv::Rect roi,
		int step_size = 1,
		bool blur = true,
		cv::Rect sliding_window = cv::Rect(0,0,0,0)) {
	typedef typename T::Leaf L;
	foreground_map = cv::Mat::zeros(roi.height, roi.width,
																	cv::DataType<float>::type);

	if(sliding_window.height < 1 || sliding_window.width < 1) {
	  ForestParam param = forest.getParam();
    sliding_window = cv::Rect(0,0, param.patch_width, param.patch_height);
	}

  if( sliding_window.width > roi.width ||
      sliding_window.height > roi.height) {
    LOG(INFO) << "sliding window is bigger then the images! sliding_window("<< sliding_window.height << ", " << sliding_window.width << "), image("<< roi.height << ", " << roi.width << " )";

	}

	for (int x = roi.x; x < roi.x + roi.width - sliding_window.width; x += step_size) {
		for (int y = roi.y; y < roi.y + roi.height - sliding_window.height; y += step_size) {

		  sliding_window.x = x;
      sliding_window.y = y;
			T s(&sample, sliding_window);
			std::vector<L*> leafs;
			forest.evaluate(&s, leafs);
			float foreground = 0.0;
			for(int i=0; i < leafs.size();i++) {
				foreground += leafs[i]->forground;
			}
			cv::Point center(x+sliding_window.width/2, y+sliding_window.height/2);
			foreground_map.at<float> (center) = foreground/leafs.size();
		}
	}

	if(blur && step_size  >  1 ) {
		cv::Mat k(cv::Size(3, 3), CV_8UC1,cv:: Scalar(1));
		cv::Mat tmp;
		cv::dilate(foreground_map, tmp, k);
		cv::blur(tmp, tmp, cv::Size(3,3));
		foreground_map =  tmp;
	}
}

// sliding window multi-class forest
template <typename T>
void eval_mc_forest(
		const Forest<T>& forest,
		const Image& sample,
    int num_classes,
		int step_size,
    cv::vector<cv::Mat>& voting_maps,
		cv::Mat& foreground_map,
		bool use_class_weights,
		bool blurr) {
  typedef typename T::Leaf L;

  cv::Rect roi(0,0, sample.width(), sample.height());
	foreground_map = cv::Mat::zeros(roi.height, roi.width,
																	cv::DataType<float>::type);
  voting_maps.resize(num_classes);
  for(int i=0; i < num_classes; i++) {
		voting_maps[i] = cv::Mat::zeros(roi.height, roi.width,
																		cv::DataType<float>::type);
  }
  std::vector<float> class_weights;

  if(use_class_weights) {
    class_weights = forest.get_class_weights();
  }else{
    class_weights.resize(num_classes+1,1);
  }
  //LOG(INFO) << ::utils::VectorToString(class_weights);
  ForestParam param = forest.getParam();
  cv::Rect sliding_window = cv::Rect(0,0, param.patch_width, param.patch_height);
  for (int x = roi.x; x < roi.x + roi.width - sliding_window.width; x += step_size) {
    for (int y = roi.y; y < roi.y + roi.height - sliding_window.height; y += step_size) {

      sliding_window.x = x;
      sliding_window.y = y;
      T s(&sample, sliding_window);
      std::vector<L*> leafs;
      forest.evaluate(&s, leafs);

      std::vector<float> class_hist(num_classes, 0);
      float foreground = 0.0;
      for(int i=0; i < leafs.size();i++) {
        const L* l = leafs[i];
        foreground += l->forground;
        for(int j=0; j < l->class_hist.size(); j++){
					class_hist[j] += l->class_hist[j] /
						static_cast<float>(l->num_samples);
        }
      }

      // normalize

      cv::Point center(x+sliding_window.width/2, y+sliding_window.height/2);


      foreground /= leafs.size();
			foreground_map.at<float> (center) = foreground;
      for(int j=0; j < class_hist.size(); j++){
        class_hist[j] /= leafs.size();

				voting_maps[j].at<float>(center) = (class_hist[j] / leafs.size());
      }
    }
  }

  if(step_size  >  1 && blurr){
    for(int i=0; i < voting_maps.size(); i++) {
      cv::blur(voting_maps[i], voting_maps[i], cv::Size(3,3));
    }
    cv::blur(foreground_map, foreground_map, cv::Size(3,3));
  }
}

} // namespace utils
} // namespace forest
} // namespace learning
