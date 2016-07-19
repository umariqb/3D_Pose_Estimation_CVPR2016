/*
 * geometry_utils.cpp
 *
 * 	Created on: Apr 26, 2013
 *      Author: gandrada
 */

#include "cpp/vision/geometry_utils.hpp"

using namespace std;
using namespace cv;

namespace vision {
namespace geometry_utils {

Rect intersect(const Rect& r1, const Rect& r2) {
  Rect intersection;

  // find overlapping region
  intersection.x = (r1.x < r2.x) ? r2.x : r1.x;
  intersection.y = (r1.y < r2.y) ? r2.y : r1.y;
  intersection.width = (r1.x + r1.width < r2.x + r2.width) ? r1.x + r1.width
      : r2.x + r2.width;
  intersection.width -= intersection.x;
  intersection.height = (r1.y + r1.height < r2.y + r2.height) ? r1.y
      + r1.height : r2.y + r2.height;
  intersection.height -= intersection.y;

  // check for non-overlapping regions
  if ((intersection.width <= 0) || (intersection.height <= 0)) {
    intersection = cvRect(0, 0, 0, 0);
  }
  return intersection;
}

bool check_intersection(const cv::Rect& r1, const cv::Rect& r2) {
  Rect intersection = intersect(r1,r2);
  if(intersection.width == r2.width && intersection.height == r2.height) {
    return true;
  }else{
    return false;
  }
}


Rect get_bbox_containing_points(const vector<Point>& points ) {
  Point min_p = points[0];
  Point max_p = points[0];

  for(int i=1; i < points.size(); i++) {
    min_p.x = std::min(points[i].x, min_p.x);
    min_p.y = std::min(points[i].y, min_p.y);
    max_p.x = std::max(points[i].x, max_p.x);
    max_p.y = std::max(points[i].y, max_p.y);
  }
  Rect bbox = Rect(min_p.x, min_p.y, max_p.x-min_p.x, max_p.y-min_p.y );
  return bbox;
}


} // namespace geometry_utils
} // namespace vision

