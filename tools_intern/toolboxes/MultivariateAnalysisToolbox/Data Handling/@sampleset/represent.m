function dat = represent(ss1,dat,ss2)

% REPRESENT expresses data in a different sampleset.
% --------------------------------
% dat2 = represent(ss1, dat1, ss2)
% --------------------------------
% Description: expresses data that is given in one sampleset, by a
%              different one. 
% Input:       {ss1} original SAMPLESET instance.
%              {dat1} either VARIABLE, GROUPING or VSMATRIX instances,
%                   represented on {ss1}.
%              {ss2} an alternative SAMPLESET.
% Output:      {dat2} the same data represented on {ss2}.

% © Liran Carmel
% Classification: Operators
% Last revision date: 25-Jul-2006

% parse input line
error(nargchk(3,3,nargin));
error(chkvar(ss1,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(ss2,'sampleset','scalar',{mfilename,inputname(3),3}));

% match the two samplesets
map = sampid(ss1,ss2.sample_names);
idx_pos_ok = find(~isnan(map));
idx_ok = map(idx_pos_ok);
len = length(map);

% discriminate between different input types
switch class(dat)
    case 'variable'
        if isscalar(dat)
            data = nan(1,len);
            data(idx_pos_ok) = dat(idx_ok);
            dat = set(dat,'data',data);
        else
            for ii = 1:numel(dat)
                data = nan(1,len);
                data(idx_pos_ok) = dat(ii,idx_ok);
                dat(ii) = set(dat(ii),'data',data);
            end
        end
    case 'grouping'
        if isscalar(dat)
            data = nan(nohierarchies(dat),len);
            data(:,idx_pos_ok) = dat(:,idx_ok);
            dat = deletesamples(dat,allbut(idx_ok,nosamples(dat)));
            dat = set(dat,'assignment',data,'naming',dat.naming);
        else
            for ii = 1:numel(dat)
                data = nan(nohierarchies(dat(ii)),len);
                data(:,idx_pos_ok) = dat(ii,:,idx_ok);
                dat(ii) = deletesamples(dat(ii),...
                    allbut(idx_ok,nosamples(dat(ii))));
                dat(ii) = set(dat(ii),'assignment',data,...
                    'naming',dat(ii).naming);
            end
        end
    case 'vsmatrix'
        if isscalar(dat)
            vr = represent(ss1,dat.variables,ss2);
            dat = set(dat,'sampleset',ss2,'variables',vr);
        else
            for ii = 1:numel(dat)
                vr = represent(ss1,dat(ii).variables,ss2);
                dat(ii) = set(dat(ii),'sampleset',ss2,'variables',vr);
            end
        end
    otherwise
        error(chkvar(dat,{'variable','vsmatrix'},{},...
            {mfilename,inputname(2),2}));
end