function gr = grouping(varargin)

% GROUPING constructor method
% -----------------------------------------------
% (1) gr = grouping()
% (2) gr = grouping(no_instances)
% (3) gr = grouping(gr0)
% (4) gr = grouping(field_name, field_value, ...)
% (5) gr = grouping(assignment1, naming1, ...)
% (6) gr = grouping(vr, samples)
% ------------------------------------------------
% Description: constructs GROUPING instance(s).
% Input:       (1) An empty default GROUPING is formed, identified by
%                  having zero number of hierarchies.
%              (2) {no_instances} integer. In this case {gr} would be an
%                  empty GROUPING vector of length {no_instances}.
%              (3) {gr0} GROUPING instance. In this case {gr} would be an
%                  identical copy.
%              (4) pairs of field names accompanied by their corresponding
%                  values.
%              (5) pairs of assignment vectors (or matrices) accompanied by
%                  their corresponding namings. The entire data is merged
%                  and the hierarchies are sorted from the coarsest to the
%                  finest.
%              (6) {vr} VARIABLE instance.
%                  <{samples}> list of samples to take into the GROUPING.
%                       By default, all samples are taken.
% Output:      {gr} GROUPING instance(s).
% Warning:     The comptability of the hierarchies is solely in the
%              responsibility of the user. No test is performed.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 15-Feb-2005

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    gr.name = 'unnamed';    % name of GROUPING
    gr.description = '';    % short verbal description
    gr.source = '';         % source of information
    gr.no_samples = 0;      % number of samples
    gr.no_hierarchies = 0;  % number of hierarchies
    gr.no_groups = [];      % number of different groups
    gr.assignment = [];     % the actual assignment vector
    gr.naming = {};         % group names
    gr.is_consistent = [];  % indicate consistency of GROUPING
    gr.gid2gcn = {};        % ID -> consecutive number
    gr.gcn2gid = {};        % consecutive number -> ID
    gr = class(gr,'grouping');
elseif isa(varargin{1},'grouping')  % case (3)
    error(nargchk(1,1,nargin));
    gr = varargin{1};
elseif isa(varargin{1},'char')      % case (4)
    % initialize
    gr = grouping;
    % use the set function
    gr = set(gr,varargin{:});
elseif isa(varargin{1},'double')    % cases (5) or (2)
    if nargin == 1      % case (2)
        gr = [];
        for ii = 1:varargin{1}
            gr = [gr grouping];
            gr(ii).name = sprintf('Grouping #%d',ii);
        end
    else                % case (5)
        % initialize
        error(chkvar(nargin,{},'even',{mfilename,'Number of Arguments',0}));
        gr = grouping;
        % read-in pairs
        for ii = 1:2:nargin
            assg = varargin{ii};
            error(chkvar(assg(~isnan(assg)),'integer','vector',...
                {mfilename,'',ii}));
            error(chkvar(varargin{ii+1},'cell',{},{mfilename,'',ii+1}));
            naming = varargin{ii+1};
            gr = gr + grouping('assignment',assg,'naming',naming);
        end
    end
elseif isa(varargin{1},'variable')  % case (6)
    % parse input line
    error(nargchk(1,2,nargin));
    error(chkvar(varargin{1},{},'vector',{mfilename,'',1}));
    vr = varargin{1};
    % initialize
    gr = [];
    % loop on all variables
    for ii = 1:length(vr)
        vrii = instance(vr,num2str(ii));
        % assign {samp}
        if nargin == 1
            samp = 1:nosamples(vrii);
        else
            samp = varargin{2};
            error(chkvar(samp,'integer',...
                {'vector',{'eqlower',nosamples(vrii)}},...
                {mfilename,'',2}));
        end
        % verify that the data are of integer intervals
        error(chkvar(diff(nanless(vrii)),'integer',{},...
            {mfilename,'Difference in assiment vector',0}));
        % generate a grouping instance
        data = round(vrii(1:end));
        if min(data) < 1
            data = data + min(data) + 1;
        end
        gr_tmp = grouping(data,vrii.lut);
        gr_tmp = deletesamples(gr_tmp,allbut(samp,nosamples(vrii)));
        gr_tmp = set(gr_tmp,'name',vrii.name,...
            'description',vrii.description);
        gr = [gr gr_tmp];
    end
end