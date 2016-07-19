function ssm_out = modify(varargin)

% MODIFY modifies sample-sample relationships.
% ------------------------------
% ssm = modify(ssm, mod_type, p)
% ------------------------------
% Description: modifies sample-sample relationships.
% Input:       {ssm} (vector of) ssmatrix instance(s).
%              {mod_type,p} what kind of modification to carry, accompanied
%                   by a list of parameters {p} (if more than one parameter
%                   is required, a cell array should be used). The options
%                   are:
%                   'mult_inter'    - multiply by a constant {f} all pairs
%                                     of samples that belong to different
%                                     classes. {p} is the cell array
%                                     {<f>,which_grp} where {f} is the
%                                     multiplicative factor (if omitted,
%                                     zero is assumed), and {which_grp}
%                                     determines the relevant grouping.
%                   'mult_intra'    - multiply by a constant {f} all pairs
%                                     of samples that belong to the same
%                                     class. {p} is the cell array
%                                     {<f>,which_grp} where {f} is the
%                                     multiplicative factor (if omitted,
%                                     zero is assumed), and {which_grp}
%                                     determines the relevant grouping.
%                   'invert'        - invert all values in matrix. {p}
%                                     can be 'safe' to instruct not to
%                                     invert zeros, or it may be left
%                                     empty.
%                   'raise'         - raise all entries by power. {p}
%                                     indicates the power.
% Output:          {ssm} updated instance(s).

% © Liran Carmel
% Classification: Transformations
% Last revision date: 13-Jan-2005

% parse input line
[ssm mod_type p] = parse_input(varargin{:});

% initialize
ssm_out = [];

% loop on all ssmatrix instances
for kk = 1:length(ssm)
    % extract matrix
    matrix = ssm(kk).matrix;
    
    % discriminate between the different modifications
    switch mod_type
        case 'mult_intra'
            grp = takespecificgroup(ssm(kk).grouping,p{2});
            g_num = grpidnum(grp);
            % verify that the matrix is square
            if get(ssm(kk),'no_rows') ~= get(ssm(kk),'no_cols')
                error('Pairwise matrix %d is not square',kk);
            end
            % loop on all groups
            for ii = 1:grp.no_groups
                samp = grp2samp(grp,g_num(ii));
                matrix(samp,samp) = p{1}*matrix(samp,samp);
            end
            % casting (unnecessary here)
            ssm_out = [ssm_out ssm(kk)];
        case 'mult_inter'
            grp = takespecificgroup(ssm(kk).grouping,p{2});
            g_num = grpidnum(grp);
            no_samples = grp.no_samples;
            % verify that the matrix is square
            if get(ssm(ii),'no_rows') ~= get(ssm(ii),'no_cols')
                error('Pairwise matrix %d is not square',kk);
            end
            % loop on all groups
            for ii = 1:grp.no_groups
                samp = grp2samp(grp,g_num(ii));
                not_samp = allbut(samp,no_samples);
                matrix(samp,not_samp) = p{1}*matrix(samp,not_samp);
            end
            % casting (unnecessary here)
            ssm_out = [ssm_out ssm(kk)];
        case 'invert'
            if p{1}
                nzeros = find(matrix ~= 0);
                matrix(nzeros) = 1 ./ matrix(nzeros);
            else
                matrix = 1 ./ matrix;
            end
            % casting (necessary here)
            switch class(ssm)
                case 'distmatrix'
                    ssm_tmp = simatrix(ssm(kk));
                    ssm_out = [ssm_out ssm_tmp];
                case 'simatrix'
                case 'dissimatrix'
            end
    end
    
    % update class
    ssm_out(kk).modifications = [ssm_out(kk).modifications ...
            struct('name',mod_type,'parameters',p)];
    ssm_out(kk).matrix = matrix;
end

% #########################################################################
function [ssm, mod_type, p] = parse_input(varargin)

% PARSE_INPUT parses input line.
% ----------------------------------------
% [ssm mod_type p] = parse_input(varargin)
% ----------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {ssm} ssmatrix instance.
%              {mod_type} type of modification.
%              {p} list of parameters.

% verify number of arguments
error(nargchk(3,3,nargin));

% first argument
error(chkvar(varargin{1},{},'vector',{mfilename,'',1}));
ssm = varargin{1};

% third argument
p = varargin{3};
if ~iscell(p)
    p = {p};
end

% second argument
error(chkvar(varargin{2},'char','vector',{mfilename,'',2}));
switch str2keyword(varargin{2},10)
    case 'mult_intra'
        mod_type = 'mult_intra';
        error(chkvar(p,{},{'vector',{'maxlength',2}},...
            {mfilename,'parameter vector',0}));
        if length(p) == 1
            p = {0,p{1}};
        end
        error(chkvar(p{1},'numerical','scalar',...
            {mfilename,'Multiplicative factor',0}));
    case 'mult_inter'
        mod_type = 'mult_inter';
        error(chkvar(p,{},{'vector',{'maxlength',2}},...
            {mfilename,'parameter vector',0}));
        if length(p) == 1
            p = {0,p{1}};
        end
        error(chkvar(p{1},'numerical','scalar',...
            {mfilename,'Multiplicative factor',0}));
    case 'invert    '
        mod_type = 'invert';
        error(chkvar(p,{},{'vector',{'maxlength',1}},...
            {mfilename,'parameter vector',0}));
        safe_mode = false;
        if ~isempty(p)
            error(chkvar(p{1},'char','vector',{mfilename,'parameter',0}));
            switch str2keyword(p{1},4)
                case 'safe'
                    safe_mode = true;
                otherwise
                    error('%s: Unfamiliar instruction',p{1});
            end
        end
        p = {safe_mode};
    otherwise
        error('%s: Unfamiliar modification',upper(varargin{2}));
end