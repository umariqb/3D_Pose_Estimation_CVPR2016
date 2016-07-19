/*
 * local_word_container.cpp
 *
 *  Created on: Sep 12, 2012
 *      Author: lbossard
 */

#include "local_word_container.hpp"

namespace vision
{
namespace features
{

LocalWordContainer::LocalWordContainer()
{
	clear();

}

LocalWordContainer::~LocalWordContainer()
{
}


void LocalWordContainer::clear()
{
	locations_.clear();
	words_.create(0,0);
	wordCount_ = 0;
	rect_ = cv::Rect(0,0,0,0);
}

} /* namespace features */
} /* namespace vision */
