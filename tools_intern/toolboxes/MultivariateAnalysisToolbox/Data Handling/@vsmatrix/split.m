function [vsm_train, vsm_test] = split(varargin)

% SPLIT splits data matrix into training set and test set.
% ----------------------------------------------------
% [vsm_train vsm_test] = split(vsm, algorithm, params)
% ----------------------------------------------------
% Description: splits data matrix into training set and test set.
% Input:       {vsm} vsmatrix instance.
%              {algorithm, params} is a pair of the algorithm name and its
%                   parameters. can be either
%                   1. 'fraction',val - randomly chooses a fraction {val}
%                       of the samples to be in the test set. {val}
%                       must be in the range [0,1].
%                   2. 'no_samples',val - randomly chooses {val} samples to
%                       be in the test set. {val} must be greater than
%                       zero and lower than the total number of samples.
%                   3. 'specific',val - takes the samples whos indices are
%                       indicated in {val} to be in the test set. {val}
%                       is a vector containing non-repeating integers, all
%                       greater than zero and lower than the total number of
%                       samples.
% Output:      {vsm_train} training dataset.
%              {vsm_test} test dataset.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 29-Nov-2005

% parse input line
[vsm train_idx test_idx] = parse_input(varargin{:});

% compute the training set
vsm_train = vsm;
vsm_train = set(vsm_train,'name',sprintf('%s training set',get(vsm,'name')));
vsm_train = deletesamples(vsm_train,test_idx);

% compute the test set
vsm_test = vsm;
vsm_test = set(vsm_test,'name',sprintf('%s test set',get(vsm,'name')));
vsm_test = deletesamples(vsm_test,train_idx);

% adjust groups in {vsm_test} to match those in {vsm_train}
vsm_test = set(vsm_test,'groupings',...
    testgrouping(vsm_train.groupings,vsm_test.groupings));

% #########################################################################
function [vsm, training_idx, test_idx] = parse_input(varargin)

% PARSE_INPUT parses input line.
% ---------------------------------------------------
% [vsm training_idx test_idx] = parse_input(varargin)
% ---------------------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {vsm} vsmatrix instance.
%              {training_idx} indices of the training set
%              {test_idx} indices of the test set.

% verify number of arguments
error(nargchk(3,3,nargin));

% first argument is always the vsmatrix
vsm = varargin{1};
error(chkvar(vsm,'vsmatrix','scalar',{mfilename,'',1}));
tot_no_samples = nosamples(vsm);

% second argument is always the algorithm
algorithm = varargin{2};
error(chkvar(algorithm,'char',...
    {'vector',{'match',{'fraction','no_samples','specific'}}},...
    {mfilename,'',2}));

% third argument is the parameter list
switch algorithm
    case 'fraction'
        error(chkvar(varargin{3},'numeric',...
            {'scalar',{'eqgreater',0},{'eqlower',1}}, ...
            {mfilename,'',3}));
        no_samples = ceil(varargin{3} * tot_no_samples);
        test_idx = subsample(1:tot_no_samples,no_samples);
    case 'no_samples'
        error(chkvar(varargin{3},'integer',...
            {'scalar',{'eqgreater',1},{'eqlower',tot_no_samples}}, ...
            {mfilename,'',3}));
        test_idx = subsample(1:tot_no_samples,varargin{3});
    case 'specific'
        error(chkvar(varargin{3},'integer',...
            {'integer',{'eqgreater',1},{'eqlower',tot_no_samples}}, ...
            {mfilename,'',3}));
        test_idx = varargin{3};
end

% compute {training_idx}
training_idx = allbut(test_idx,tot_no_samples);

% check for errors
if isempty(training_idx) || isempty(test_idx)
    error('either test set or training set are empty');
end