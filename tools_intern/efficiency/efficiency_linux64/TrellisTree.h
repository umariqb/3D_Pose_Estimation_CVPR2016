
#include "mex.h"

#ifndef TRELLISTREE
#define TRELLISTREE


class TrellisNode
{
    public:
    unsigned int  uiGap;
    unsigned int  uiValue;
    unsigned int  uiDepth;
    unsigned int  uiFrame;

    double        dWeight;
    double        dAccWeight;
    
    TrellisNode  *TNParent;
    TrellisNode  *TNChilds;
    
    
    TrellisNode()
    {

    }
    
    TrellisNode(unsigned int uiVal, unsigned int uiG, unsigned int uiF)
    {

        uiGap     = uiG;
        uiValue   = uiVal;
        uiFrame   = uiF;
        uiDepth   = 0;
        
          dWeight = 0;
       dAccWeight = 0;
        
        TNChilds  = new TrellisNode[uiGap];
        TNParent  = NULL;

    }
    
    TrellisNode(unsigned int uiVal, unsigned int uiG, unsigned int uiF, double dW)
    {

        uiGap     = uiG;
        uiValue   = uiVal;
        uiFrame   = uiF;
        uiDepth   = 0;
        
          dWeight = dW;
       dAccWeight = dW;
        
        TNChilds  = new TrellisNode[uiGap];
        TNParent  = NULL;

    }
    
    TrellisNode(unsigned int uiVal, unsigned int uiG, TrellisNode *par)
    {

        uiGap   = uiG;
        uiValue = uiVal;
        
        uiDepth = par->uiDepth+1;
        uiFrame = par->uiFrame+1;
        
        dWeight = 0;
     dAccWeight = par->dAccWeight+dWeight;
        
        TNChilds  = new TrellisNode[uiGap];
        TNParent  = par;
        
    }
    
    TrellisNode(unsigned int uiVal, unsigned int uiG, TrellisNode *par, double dW, unsigned int uiF)
    {

        uiGap   = uiG;
        uiValue = uiVal;
        
        uiDepth = par->uiDepth+1;
        uiFrame = par->uiFrame+uiF;
        
        dWeight = dW;
     dAccWeight = par->dAccWeight+dWeight;
        
        TNChilds  = new TrellisNode[uiGap];
        TNParent  = par;
        
    }
    
    ~TrellisNode(){
    }
    
    void addChild(unsigned int uiVal, unsigned int uiG){

        TrellisNode NewNode(uiVal,uiGap,this);
        TNChilds[uiG]=NewNode;
        
    }
    
    void addChild(unsigned int uiVal, unsigned int uiG, double dW,unsigned int uiF){

        TrellisNode NewNode(uiVal,uiGap,this,dW,uiF);
        TNChilds[uiG]=NewNode;
        
    }
    
    TrellisNode* getChild(unsigned int uiChild){
  
        return &TNChilds[uiChild];
 
    }
    
    TrellisNode* getParent(){

        return TNParent;
        
    }
    
 };
 
 class TrellisTree{

     public:
     unsigned int uiGap;
     
     TrellisNode* root;
     TrellisNode* deepNode;
     TrellisNode* curNode;
     
     TrellisTree(unsigned int val, unsigned int gap, unsigned int frame){
        root     = new TrellisNode(val,gap,frame);
        deepNode = root;
        curNode  = root;
        uiGap    = gap;
     }
     
     ~TrellisTree(){}
     
     TrellisNode* getCurNode(){
        return curNode;
     }
     
     TrellisNode* getDeepNode(){
         return deepNode;
     }
     
     TrellisNode* getRootNode(){
        return root;
     }
     
     void setDeepNode(TrellisNode* candidate){
        
// //          mexPrintf("sDN: can=%f dep=%f\n",candidate->dAccWeight,deepNode->dAccWeight);
// //          mexPrintf("sDN: can=%i dep=%i\n",candidate->uiDepth,deepNode->uiDepth);
// //          mexPrintf("sDN: can=%i dep=%i\n\n",candidate->uiFrame,deepNode->uiFrame);
         
//          if((candidate->uiDepth)>(deepNode->uiDepth)){
//              deepNode=candidate;
//              mexPrintf(".");
//          }
//          else{
//          (candidate->uiDepth) == (deepNode->uiDepth) && 

//             if(deepNode->uiDepth==0){//Root{
         
                deepNode=candidate;
//             }
//             else{
//                 if((candidate->dAccWeight / candidate->uiDepth)<(deepNode->dAccWeight/deepNode->uiDepth)){
//                          deepNode=candidate;
//                          mexPrintf("+\n");
//                 }
//                 else{
//                     if((candidate->uiFrame)>(deepNode->uiFrame)){
//                         deepNode=candidate;
//                          mexPrintf("*\n");
//                     }
//                 }
//             }
     }
     
     void setCurNode(TrellisNode* newCurNode){
        curNode=newCurNode;
     }
     
 };
 #endif
