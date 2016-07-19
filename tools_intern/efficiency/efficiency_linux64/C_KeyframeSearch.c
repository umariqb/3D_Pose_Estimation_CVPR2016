#define _LINUX_

#include "mex.h"
#include "matrix.h"
#include <stdio.h>

#if ( defined(_LINUX_) && !defined(_WINDOWS_) )
	#include <algorithm>
	#include <stdlib.h>
	using namespace std;
#endif

//#define DEBUG




//      vDistanceMinMax(k,i): k-th keyframe. i=0: minDistance. i=1: maxDistance.
#define vDistanceMinMax(k,i)        (*(pDistanceMinMax+(K-1)*(i)+(k)))

//      vKeyframeBucket(d,k): d = document number (starting from 0), k = keyframe number.
#define vKeyframeBucket(d,k)        (*(pKeyframeBuckets + ((k)*numDocuments + (d))))

#define vBucketSizes(d,k)           (*(pBucketSizes + ((k)*numDocuments + (d))))

#define vCurrentMaxBucketSizes(d,k) (*(pCurrentMaxBucketSizes + ((k)*numDocuments + (d))))

//      vIntersection(k,i): k = keyframe number, i=0: start of intersection, i=1: end of intersection
#define vIntersection(k, i)         (*(pIntersection+K*(i)+(k)))
//      vSegments(s,i): s = segment number, i=0: document ID (starting from 1!!), i=1: start frame, i=2: end frame
#define vSegments(s, i)             (*(pSegments+3*(s)+(i)))

//memory is reserved for SEGMENT_INCREMENT resulting segments at the beginning of the program.
//if the actual number of segmends exceeds this number, then memory for another SEGMENT_INCREMENT 
//segments is reserved (and so on).
#define SEGMENT_INCREMENT 64

#define BUCKET_INCREMENT 32

/* max and min already defined.
#define max(a,b) (a)<(b)?(b):(a)
#define min(a,b) (a)<(b)?(a):(b)
*/
int K,							// number of keyframes
	numDocuments,				// number of documents
	currentMaxSegments,			// for how many output segments has memory been allocated
	numSegmentsFound,			// this number tells how many output segments have already been found.
	* pBucketSizes,				// length of each keyframe bucket. Use with vBucketSized(d,k)
	* pCurrentMaxBucketSizes,   // for each keyframe bucket, for how many elements has memory been allocated
	* keyframePointer;		    // used for the recursive function: saves the current position inside the 
								// keyframe buckes for each keyframe

double extendLeft,				// saves how many frames each hit should be extended to the left
	   extendRight,				// saves how many frames each hit should be extended to the right
	   * pDistanceMinMax,		// for each keyframe the max and min distance to the next keyframe. 
								// use with vDistanceMinMax(k,i)
	   * pDocumentLength,		// length of each document in frames
	   * pIntersection,			// used for the reconstruction of hits. Saves the intersection intervals 
								// during the recursion
	   * pSegments,				// Pointer to the output segments. Use with vSegments
	   * pKeyframeIndex,		// for each keyframe it saves to which Index in the indexArray the keyframe belongs	
	   ** pKeyframeBuckets;		// For each keyframe and for each document the segments of the inverted lists are saved.


mxArray ** pIndexArraySegments; //for each index in the indexArray it saves a pointer to the segments of the inverted lists.





#define FLOAT_FTOI_MAGIC_NUM (float)(3<<21)
#define IT_FTOI_MAGIC_NUM (0x4ac00000)

int FastFloatToInt(float f)
{
	f += FLOAT_FTOI_MAGIC_NUM;
	return (*((int*)&f) - IT_FTOI_MAGIC_NUM)>>1;
}

#ifdef DEBUG
void printIntersections()
{
    int k;
    for (k=0; k<K; k++)
    {
       mexPrintf("Intersection_%i: (%.0f, %.0f)\n", k, vIntersection(k,0), vIntersection(k,1));
    }   
}

void printSegments()
{
    int s;
    mexPrintf("######### Segments: %i\n", numSegmentsFound);
    for (s=0; s<numSegmentsFound; s++)
    {
       mexPrintf("Segment %.0f: (%.0f, %.0f)\n", vSegments(s,0), vSegments(s,1), vSegments(s,2));
    }   
}

void printDistance() 
{
    int k;
    for (k=0; k < K-1; k++)
    {
        mexPrintf("k: %2i, min: %2.0f, max: %2.0f \n", k, vDistanceMinMax(k, 0), vDistanceMinMax(k, 1));
    }
}

void printBuckets()
{
    int d, k, cols, c;
   // int idx[2];
    double * pListData;
    
    //print all inverted lists 
    for (d=0; d<numDocuments; d++)
    {
        mexPrintf("Document %i\n", d);
       // idx[0] = d;
        for (k=0; k<K; k++)
        {
            mexPrintf(" Keyframe %i\n", k);
            if (vBucketSizes(d,k) == 0)
            {
                mexPrintf("  Emtpy.\n");
            }
            else 
            {
                pListData = vKeyframeBucket(d,k);
                // get data of the keyframelist
                cols = vBucketSizes(d,k); //columns
                mexPrintf("  Length: %i\n", cols);
                // print the data
                mexPrintf("  ");
                for(c=0; c < cols; c++)
                {
                    mexPrintf("%2.0f ", *(pListData+c));
                }
                mexPrintf("\n");
            }
        }
    }   
}
#endif


void searchRecursive(int d, int k, double allowedRangeStart, double allowedRangeEnd)
{
    double * listData;
    int listLength, t, c;
    double chosenFrame, IEnd, IStart, JEnd, JStart, 
           hitStart, hitEnd, segmentStart, segmentEnd,
           nextAllowedRangeStart, nextAllowedRangeEnd;
    bool found;
    #ifdef DEBUG  
        mexPrintf("Recursive: Document %3i, Keyframe %2i, Range: (%.0f, %.0f)\n", 
                    d+1, k, allowedRangeStart, allowedRangeEnd);
	#endif

    listData = vKeyframeBucket(d,k);
    listLength = vBucketSizes(d,k);

    #ifdef DEBUG 
    {
        mexPrintf("List length: %i \n", listLength);
        for(c=0; c < listLength; c++)
        {
            mexPrintf("%2.0f ", *(listData+c));
        }
        mexPrintf("\n");
        mexPrintf("Pointer: %i \n", keyframePointer[k]);
    }
	#endif

    // forward listpointer until we are in the allowedRange
    // while the minimum of the allowed interval is less then
    // the maximum of the keyframe interval an intersection is impossible.
    while ((keyframePointer[k] < listLength ) && (allowedRangeStart > listData[keyframePointer[k]+1]))
    {
        keyframePointer[k] = keyframePointer[k] + 2;
    }
    // now the keyframePointer[k] either points into the
    // allowedRange or behind the allowedRange.
    
    if (k == K-1) //if the current keyframe is the last one
    {
        // this is the last keyframe. Report any hits.
        // while the allowedRange interval intersects the keyframe interval
        // report any hit.
        found = false;
        while (keyframePointer[k] < listLength
                && allowedRangeEnd >= listData[keyframePointer[k]]
                && allowedRangeStart <= listData[keyframePointer[k]+1])
        {
            found = true;
            #ifdef DEBUG 
            {
                mexPrintf("Hit found, document: %i\n", d+1);
                mexPrintf("Pointer: ");
                for (c=0; c < K; c++)
                {
                    mexPrintf("%i ", keyframePointer[c]);
                }
                mexPrintf("\n");
            }
			#endif
            
            vIntersection(k, 0) = max(listData[keyframePointer[k]], allowedRangeStart);
            vIntersection(k, 1) = min(listData[keyframePointer[k]+1], allowedRangeEnd);
            
            #ifdef DEBUG  
				printIntersections();
			#endif
            
            // Reconstruction of hits: Convert a match (a set of pointers
            // into the segmented inverted list) into a hit (a set of frames
            // inside the segments. the stiffness condition holds for these
            // frames).           
            
            chosenFrame = vIntersection(k,0); //starte Reconstruction mit linkesten Wert der IntersectionK
            #ifdef DEBUG 
				mexPrintf("   Chosen Frame: %.0f\n", chosenFrame); 
			#endif
            for ( t=K-2; t>=0; t-- )
            {
                
                IStart = chosenFrame - vDistanceMinMax(t,1);
                IEnd = chosenFrame - vDistanceMinMax(t,0);
                #ifdef DEBUG 
					mexPrintf("   I: (%.0f, %.0f)\n", IStart, IEnd);
					mexPrintf("   Intersection: (%.0f, %.0f)\n", vIntersection(t,0), vIntersection(t,1));
				#endif
                JStart = max(IStart, vIntersection(t,0));
                JEnd =  min(IEnd, vIntersection(t,1));
                #ifdef DEBUG 
					mexPrintf("   J: (%.0f, %.0f)\n", JStart, JEnd); 
				#endif
                if (JStart > JEnd)
                    mexErrMsgTxt("Error in the reconstruction of hits: An illegal interval occured!");
                chosenFrame = JStart;
                #ifdef DEBUG 
					mexPrintf("   Chosen Frame: %.0f\n", chosenFrame);     
				#endif
                           
            }
            #ifdef DEBUG 
				mexPrintf("   Reconstruction of hits done.");     
			#endif
            hitStart = chosenFrame; //leftmost frame
            hitEnd = vIntersection(k,1); //rightmost frame
            
            segmentStart = max(hitStart - extendLeft, 1.0);
            segmentEnd = min(hitEnd + extendRight,   pDocumentLength[d]);
            //now extend the hit and remove overlappings
            #ifdef DEBUG 
				mexPrintf("Hit segment: (%.0f, %.0f)\n", segmentStart, segmentEnd);
			#endif
            //mexPrintf("Segment start: %.0f", segmentStart);
            if (    (numSegmentsFound > 0) //this is not the first hit
                 && ( (d+1) == (int)(vSegments(numSegmentsFound-1,0)+0.5) ) //document ID is the same
                 && ( segmentStart <= vSegments(numSegmentsFound-1,2) ) ) // the startframe of this segment is less than the end frame of the preceeding segment
            {
                //the segments overlap. conjoin them.
                #ifdef DEBUG 
                {
                    mexPrintf("Joining hits (%.0f, %.0f) and (%.0f, %.0f) in document %i\n", 
                    vSegments(numSegmentsFound-1,1), vSegments(numSegmentsFound-1,2),
                    segmentStart, segmentEnd, d+1);
                }
				#endif
                vSegments(numSegmentsFound-1, 2) = segmentEnd;                    
            }
            else
            {   //the hits don't overlap, so create a new one
                if (numSegmentsFound >= currentMaxSegments)
                {
                    // reallocate more memory
                    currentMaxSegments = currentMaxSegments + SEGMENT_INCREMENT;
                    #ifdef DEBUG 
						mexPrintf("Reallocating memory for %i segments\n", currentMaxSegments);
					#endif
		
                    pSegments =(double*) mxRealloc(pSegments, 3*currentMaxSegments*sizeof(pSegments[0]));
                }
                vSegments(numSegmentsFound,0) = d+1; //caution: document indices in matlab start from 1 and not from 0.
                vSegments(numSegmentsFound,1) = segmentStart;
                vSegments(numSegmentsFound,2) = segmentEnd;
                numSegmentsFound++;
            }                
            keyframePointer[k] = keyframePointer[k] + 2;
        }
        if (found)
        {
            keyframePointer[k] = keyframePointer[k] - 2;
        }
    }
    else // This is not the last keyframe
    {
        found = false;
        while (keyframePointer[k] < listLength
                && allowedRangeEnd >= listData[keyframePointer[k]]
                && allowedRangeStart <= listData[keyframePointer[k]+1])
        {
            found = true;

            vIntersection(k, 0) = max(listData[keyframePointer[k]], allowedRangeStart);
            vIntersection(k, 1) = min(listData[keyframePointer[k]+1], allowedRangeEnd);
            #ifdef DEBUG 
				printIntersections();
			#endif
            
            nextAllowedRangeStart = vIntersection(k,0) + vDistanceMinMax(k,0);
            nextAllowedRangeEnd   = vIntersection(k,1) + vDistanceMinMax(k,1);
            

            //recurse
            searchRecursive(d, k+1, nextAllowedRangeStart, nextAllowedRangeEnd);
            keyframePointer[k] = keyframePointer[k] + 2;
        }
        if (found)
        {
            keyframePointer[k] = keyframePointer[k] - 2;
        }
    }
}

void startRecursion()
{
    double * listData;
    int d,k;
    bool isOneListEmpty = false;
    double allowedRangeStart;
    double allowedRangeEnd;
    int listLength;
    
    //for each document
    for ( d=0; d < numDocuments; d++ )
    {
        //for each keyframelist check if one list is empty.
        //if one list is empty then skip this document.
        isOneListEmpty = false;
        for ( k=0; k < K; k++ )
        {
            if ( vBucketSizes(d,k) == 0 )
            {
                isOneListEmpty = true;
                break;
            }
        }
        if (isOneListEmpty)
        {
            #ifdef DEBUG 
				mexPrintf("Document %i: One bucket empty.\n", d);
			#endif
            continue;
        }
        
        //now I can be sure that the cells aren't empty.
        listData =  vKeyframeBucket(d,0);
        listLength = vBucketSizes(d,0);
        
        //initialize keyframepointers:
        for ( k=0; k < K; k++ )
        {
            keyframePointer[k] = 0;
        }
        while (keyframePointer[0] < listLength)
        {
            vIntersection(0,0) = listData[keyframePointer[0]];
            vIntersection(0,1) = listData[keyframePointer[0]+1];

            allowedRangeStart = vIntersection(0,0) + vDistanceMinMax(0,0);
            allowedRangeEnd   = vIntersection(0,1) + vDistanceMinMax(0,1);
            #ifdef DEBUG 
				printIntersections();
			#endif
            searchRecursive(d, 1, allowedRangeStart, allowedRangeEnd);
            keyframePointer[0] = keyframePointer[0] + 2;
        }

    }
}






void convertKeyframeList(const mxArray * pKeyframeList)
{
	int fieldNumberFramesStart,
		fieldNumberFramesLength,
		listLength,
		docID, 
		lastDocID, 
		segmentID, 
		lastSegmentID,
		k, 
		n,
		keyframeIndex;
    
	double segmentStart, 
		   segmentLength,
		   * pListData;

    mxArray * pKeyframeListCell,
			* pDocFramesStart,
			* pDocFramesLength;

    fieldNumberFramesStart = mxGetFieldNumber(pIndexArraySegments[0], "frames_start");
    fieldNumberFramesLength = mxGetFieldNumber(pIndexArraySegments[0], "frames_length");
    
    for ( k=0;  k < K; k++ )
    {
        pKeyframeListCell = mxGetCell(pKeyframeList, k);
        listLength = mxGetN(pKeyframeListCell);
        pListData = (double*)mxGetData(pKeyframeListCell);
        keyframeIndex = (int)((pKeyframeIndex[k]+0.5))-1;
        
        lastDocID = -1;
        lastSegmentID = -1;
        
        #ifdef DEBUG 
			mexPrintf("Keyframelist %i, list length: %i\n", k, listLength);
		#endif
        for ( n = 0; n < listLength; n++ )
        {
            docID = (int)(pListData[2*n]-0.5); //docID in Matlab begins with 1, in C it begins with 0.
            segmentID = (int)(pListData[2*n+1]-0.5); //segment ID in Matlab begins with 1, in C it begins with 0.
            #ifdef DEBUG 
				mexPrintf(" docID: %i,  segment id: %i\n", docID, segmentID);
			#endif

            pDocFramesStart = mxGetFieldByNumber(pIndexArraySegments[keyframeIndex], docID, fieldNumberFramesStart);
            pDocFramesLength = mxGetFieldByNumber(pIndexArraySegments[keyframeIndex], docID, fieldNumberFramesLength);
            
            segmentStart = ((double*)mxGetData(pDocFramesStart))[segmentID];
            segmentLength = ((double*)mxGetData(pDocFramesLength))[segmentID];
            #ifdef DEBUG 
				mexPrintf(" Segment start: %.0f Segment length: %.0f\n", segmentStart, segmentLength);
			#endif
            if ((docID == lastDocID) && (segmentID == (lastSegmentID+1)))
            {
                /* Zwei Segmente lagen direkt nebeneinander.
                % Vereinige sie, indem das letzte gespeicherte Element im
                % aktuellen Keyframebucket verl�ngert wird.
                % ("Nachsegmentieren")
                 */
                #ifdef DEBUG 
					mexPrintf("Nachsegmentierung. ", vCurrentMaxBucketSizes(docID,k));
				#endif
                vKeyframeBucket( docID, k )[vBucketSizes(docID,k)-1] = segmentStart + segmentLength - 1;
            }
            else 
            {
                if (docID != lastDocID && lastDocID != -1)
                {
                    /* die Liste zu lastDocID ist fertig erstellt. Die Gr��e kann nun mit
                     * realloc exakt angepasst werden 
                     */
                    if (vCurrentMaxBucketSizes(lastDocID,k) > 0)
                    {
                        #ifdef DEBUG 
							mexPrintf("Anpassen des Speicherbereiches f�r die fertig erstellte Liste (%i, %i).\n", lastDocID, k);
						#endif
                        vKeyframeBucket(lastDocID, k) = 
                            (double*) mxRealloc(vKeyframeBucket(lastDocID, k), 2* vCurrentMaxBucketSizes(lastDocID,k)*sizeof(double));
                    }
                    
                }
                #ifdef DEBUG 
					mexPrintf("Neues Segment anlegen. \n");
					mexPrintf("Aktuelle Gr��e: %i", vBucketSizes(docID,k));
					mexPrintf(" maximale Gr��e: %i\n " , vCurrentMaxBucketSizes(docID, k));
				#endif
                lastDocID = docID;
                if (vBucketSizes(docID,k) >= vCurrentMaxBucketSizes(docID, k))
                {
                    #ifdef DEBUG 
						mexPrintf("Reallocating memory: current bucket size: %i \n", vCurrentMaxBucketSizes(docID,k));
					#endif
                    // reallocate more memory
                    vCurrentMaxBucketSizes(docID,k) = vCurrentMaxBucketSizes(docID,k) + BUCKET_INCREMENT;
                    #ifdef DEBUG 
						mexPrintf("Reallocating memory for %i segments in bucket (%i,%i)\n", vCurrentMaxBucketSizes(docID,k), docID, k);
					#endif
                    vKeyframeBucket(docID, k) = 
                        (double*) mxRealloc(vKeyframeBucket(docID, k), 2* vCurrentMaxBucketSizes(docID,k)*sizeof(double));
                }
                
                
                vKeyframeBucket(docID,k)[vBucketSizes(docID, k)] = segmentStart;
                vKeyframeBucket(docID,k)[vBucketSizes(docID, k)+1] = segmentStart + segmentLength - 1;
                vBucketSizes(docID,k) = vBucketSizes(docID,k)+2;
            }
            lastSegmentID = segmentID;
        }           
        /*Speicherbereich f�r das letzte Dokument der Liste anpassen
         */
        if (vCurrentMaxBucketSizes(docID,k) > 0)
        {
            #ifdef DEBUG 
				mexPrintf("Anpassen des Speicherbereiches f�r die fertig erstellte letzte Liste (%i, %i).\n", lastDocID, k);
			#endif
            vKeyframeBucket(docID, k) = 
                (double*) mxRealloc(vKeyframeBucket(docID, k), 2* vCurrentMaxBucketSizes(docID,k)*sizeof(double));
        }
    } 
}





void mexFunction(int nlhs, mxArray *plhs[], 
    int nrhs, const mxArray *prhs[])
{
    int i,
		k,
    listNr,
		fieldNumberFilesNum,
		fieldNumberSegments,
		indexSize;		
	double* pOut;
    const mxArray * pIndexArray;
	const mxArray * pKeyframeList;	
  const mxArray * list;
	mxArray * output;


    if (nrhs < 1 || !mxIsStruct(prhs[0]))
        mexErrMsgTxt("First argument has to be a struct array (indexArray)");

    pIndexArray = prhs[0];

    fieldNumberFilesNum = mxGetFieldNumber(pIndexArray, "files_num");
	numDocuments = (int)(mxGetScalar(mxGetFieldByNumber(pIndexArray, 0, fieldNumberFilesNum))+0.5);
    pDocumentLength = (double*)mxGetPr(mxGetField(pIndexArray, 0, "files_frame_length"));
    
    fieldNumberSegments = mxGetFieldNumber(pIndexArray, "segments");
    
    #ifdef DEBUG 
		mexPrintf( "Segments field number: %i\n", fieldNumberSegments);
	#endif
    
    i=mxGetN(pIndexArray);
    k=mxGetM(pIndexArray);
    #ifdef DEBUG 
		mexPrintf( "Array dimension: %i %i\n", i, k);
	#endif
    
    //create a pointer array to the segments of every index structure
    indexSize = mxGetN(pIndexArray);
    pIndexArraySegments =  (mxArray **) mxCalloc(indexSize, sizeof(mxArray *));
    for (i=0; i < indexSize; i++)
    {
        pIndexArraySegments[i] = mxGetFieldByNumber(pIndexArray, i, fieldNumberSegments);
    }
    

    if (nrhs < 2 || !mxIsCell(prhs[1]))
        mexErrMsgTxt("Second argument has to be a cell array (the keyframe lists)");
   
 
    if (nrhs < 3 || !mxIsDouble(prhs[2]))
        mexErrMsgTxt("Third argument has to be a double vector (the keyframeIndex)");
    
    pKeyframeIndex = (double*) mxGetData(prhs[2]);
    
    pKeyframeList = prhs[1];
    
    i=mxGetN(pKeyframeList);
    k=mxGetM(pKeyframeList);
    
    for (listNr = 0; listNr < k*i; listNr++)
    {
      list = mxGetCell(pKeyframeList, listNr);
      if (list == NULL || mxIsEmpty(list))
      {
        // one keyframe list is empty --> there can't be any hits.
        plhs[0] = mxCreateDoubleMatrix(3, 0, mxREAL);    
        return;
      }

    
    
    }

    #ifdef DEBUG 
		mexPrintf( "keyframe list dimension: %i %i\n", i, k);
	#endif
    
    // the number of keyframes is the length of the keyframe list cell array.
    K = mxGetN(pKeyframeList);
    
    pKeyframeBuckets = (double**) mxCalloc(numDocuments*K, sizeof(double*));
    pBucketSizes = (int*) mxCalloc(numDocuments*K, sizeof(int));
    pCurrentMaxBucketSizes = (int*) mxCalloc(numDocuments*K, sizeof(int));
    //memset(pBucketSizes, 0, (numDocuments*K)* sizeof(int));
    //memset(pCurrentMaxBucketSizes, 0, (numDocuments*K)* sizeof(int));
    
   
    convertKeyframeList(pKeyframeList);
    
   
    #ifdef DEBUG 
		mexPrintf("%i Keyframes, %i Documents\n", K, numDocuments);
		printBuckets();
	#endif
    
    if (nrhs < 4 || !mxIsDouble(prhs[3]))
        mexErrMsgTxt("Fourth argument has to be a double matrix (distanceMinMax-Matrix)");
    i = mxGetN(prhs[3]); //columns
    k = mxGetM(prhs[3]); //rows
    pDistanceMinMax = mxGetPr(prhs[3]);
    
    if (i != 2)
         mexErrMsgTxt("DistanceMinMax has to have 2 columns.");
    if (k != (K-1))
       mexErrMsgTxt("Dimension of distanceMinMax doesn't match keyframeBuckets.");

    if (nrhs < 5 || !mxIsDouble(prhs[4]))
        mexErrMsgTxt("Third argument has to be a double vector conaining the length of each document");
    
    if (nrhs < 6 || !mxIsDouble(prhs[5]))
        mexErrMsgTxt("Fourth argument has to be a double scalar");

    extendLeft = *(mxGetPr(prhs[4]));
    extendRight= *(mxGetPr(prhs[5]));
    
    #ifdef DEBUG 
		printDistance();
		mexPrintf("Left: %.0f Right: %.0f\n", extendLeft, extendRight);
	#endif
    
    // initialize the returned structure to currentMaxHits hits
    // dynamically reallocate more memory if needed in the recursive function.
    currentMaxSegments = SEGMENT_INCREMENT;
    numSegmentsFound = 0;
    pSegments =(double*)  mxCalloc(3*currentMaxSegments, sizeof(double));
  
    keyframePointer = (int*) mxCalloc(K, sizeof(int));
    pIntersection = (double*) mxCalloc(2*K, sizeof(double));
    
    startRecursion();
    
    //assign output variable
    output = mxCreateDoubleMatrix(3, numSegmentsFound, mxREAL);    
    //mexMakeArrayPersistent(output);
    //mexAtExit(mexExit); //free memory when output variable is cleared in matlab.
    pOut = mxGetPr(output);
    //fill output array with the segments found.
    memcpy(pOut, pSegments, 3*numSegmentsFound*sizeof(double));
    plhs[0] = output;
    
    mxFree(keyframePointer);
    mxFree(pIntersection);
    mxFree(pSegments);
 
    mxFree(pBucketSizes);
    mxFree(pCurrentMaxBucketSizes);
    
    for ( i = 0; i <  numDocuments*K; i++)
        mxFree(pKeyframeBuckets[i]);
    mxFree(pKeyframeBuckets);
}

