/*
 * FixedPriorityQueue.hpp
 *
 *  Created on: Dec 18, 2008
 *      Author: lbossard
 */

#ifndef UTILS_DATA_STRUCUTRES_FIXEDPRIORITYQUEUE_HPP_
#define UTILS_DATA_STRUCUTRES_FIXEDPRIORITYQUEUE_HPP_

#include <set>

namespace utils
{
namespace data_structure
{
/**
*  @brief  A container automatically sorting its contents .
*
*  @ingroup Containers
*  @ingroup Sequences
*
*  This is not a true container, but an @e adaptor.  It holds
*  another container, and provides a wrapper interface to that
*  container.  The wrapper is what enforces priority-based sorting
*  and %queue behavior.  Very few of the standard container/sequence
*  interface requirements are met (e.g., iterators).
*
*  The second template parameter supplies the means of making
*  priority comparisons.  It defaults to @c less<value_type> but
*  can be anything defining a strict weak ordering.
*
*  Members not found in "normal" containers are @c container_type,
*  which is a typedef for the second Sequence parameter, and @c
*  push, @c pop, and @c top, which are standard %queue operations.
*
*  @note No equality/comparison operators are provided for
*  %priority_queue.
*
*/
template < typename T, typename Compare = std::less<T> >
class FixedPriorityQueue
{
public:
    typedef typename std::set<T, Compare>			_HeapImplType;
    typedef typename _HeapImplType::iterator		iterator;
    typedef typename _HeapImplType::const_iterator	const_iterator;
    typedef typename _HeapImplType::const_reference	const_reference;
    typedef typename _HeapImplType::size_type		size_type;


    /**
    *  @brief  Default constructor creates no elements.
    */
    explicit
    FixedPriorityQueue(
            const unsigned int capacity,
            const Compare & __x = Compare()
            )
    :
        mCompare(__x),
        mCapacity(capacity),
        mHeap(mCompare)
    {
    };

    virtual ~FixedPriorityQueue()
    {

    }
    /**
    *  @brief  Add data to the %queue.
    *  @param  x  Data to be added.
    *
    *  This is a typical %queue operation.
    *  The time complexity of the operation depends on the underlying
    *  sequence.
    */
    void push(const T & __x)
    {
        try
        {
            // if we are not full --> add
            if (!full())
            {
                mHeap.insert(__x);
            }
            // we are full
            else
            {
                iterator lastElem = --mHeap.end();

                // check, if we have to insert
                if (mCompare(__x, *lastElem))
                {
                    // remove last element
                    mHeap.erase(lastElem);

                    // insert new element
                    mHeap.insert(__x);
                }
            }
        }
        catch (...)
        {
            mHeap.clear();
            throw;
        }
    };

    /**
     *  @return Returns true if the %queue is empty.
     */
    inline bool
    empty() const { return mHeap.empty(); }

    /**
     * @return Returns true if the %queue is full.
     */
    inline bool
    full() const { return ( size() >= capacity() );}

    /**  Returns the number of elements in the %queue.  */
    inline size_type
    size() const { return mHeap.size(); }

    /**  Returns the capacity of elements of the %queue.  */
    inline size_type
    capacity() const { return mCapacity; }

    /**
    *  Returns a read-only (constant) reference to the data at the first
    *  element of the %queue.
    */
    inline const_reference
    top() const
    {
        return *mHeap.begin();
    }

    /**
    *  Returns a read-only (constant) reference to the data at the first
    *  element of the %queue.
    */
    inline const_reference
    bottom() const
    {
        return *(--mHeap.end());
    }

    /**
    *  @brief  Removes first element.
    *
    *  This is a typical %queue operation.  It shrinks the %queue
    *  by one.  The time complexity of the operation depends on the
    *  underlying sequence.
    *
    *  Note that no data is returned, and if the first element's
    *  data is needed, it should be retrieved before pop() is
    *  called.
    */
    void
    pop()
    {
        try
        {
            mHeap.erase(mHeap.begin());
        }
        catch(...)
        {
            mHeap.clear();
            throw;
        }
    }

    /**
    *  Returns a read/write iterator that points to the first element in the
    *  %set.  Iteration is done in ascending order according to the keys.
    */
    inline iterator
    begin() const
    { return mHeap.begin(); }

    /**
    *  Returns a read/write iterator that points one past the last element in
    *  the %set.  Iteration is done in ascending order according to the keys.
    */
    inline iterator
    end() const
    { return mHeap.end(); }


protected:
    Compare mCompare;
    const unsigned int mCapacity;
    _HeapImplType mHeap;

private:
    // we dont want to be default constructable
    FixedPriorityQueue();
};

}
}

#endif /* UTILS_DATA_STRUCUTRES_FIXEDPRIORITYQUEUE_HPP_ */
