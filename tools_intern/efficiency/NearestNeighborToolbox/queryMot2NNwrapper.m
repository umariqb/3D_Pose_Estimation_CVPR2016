function res = queryMot2NNwrapper(skel,mot,DBhandle,varargin)

    switch nargin
        case 3
            FSet   = 'e15';
            sFrame = 1; 
            eFrame = mot.nframes;
            numNei = 256;
        case 4 
            FSet   = varargin{1};
            sFrame = 1; 
            eFrame = mot.nframes;
            numNei = 256;
        case 6
            FSet   = varargin{1};
            sFrame = varargin{2};
            eFrame = varargin{3};            
            numNei = 256;
        case 7
            FSet   = varargin{1};
            sFrame = varargin{2};
            eFrame = varargin{3};            
            numNei = varargin{4};
        otherwise
            error('Wrong num of Args!\n');
    end

    mot      = prepareMotForQuery(skel,mot);
    Qmat     = extractFeatureSetFromMot(mot,FSet);
    Qmat     = Qmat(:,sFrame:eFrame);
    Qhandle  = NN_createSampleSet(Qmat);

   [res.numSS,res.weights,res.motIDs,res.Segs] = nn_wrapper(                           ...
                                                              'call',                  ...
                                                              cast(DBhandle,'uint32'), ...
                                                              'findNearestSampleSets', ...
                                                              cast( Qhandle,'uint32'), ...
                                                              numNei);

end