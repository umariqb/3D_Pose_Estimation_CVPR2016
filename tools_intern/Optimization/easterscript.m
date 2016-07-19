fid = fopen('correlations.txt','wt');

distMeasures    = {'pc1','pc11','euler','quat','wb'};
featureSets     = {'pva20','pca8','pca16','pca25','e15','e27','e30','e39','e15_45','e15_75','e30_90'};

res = cell(1,size(distMeasures,2)+size(featureSets,2));

D = zeros(numel(distMeasures)+numel(featureSets),numel(distMeasures)+numel(featureSets),2);

fprintf(fid,'\\begin{tabular}{lrrrrrrrrrrrrrrrrrr}\n');
for i=1:numel(distMeasures)
    fprintf('-----------distMeasure %s (%i/%i)-----------\n',distMeasures{i},i,numel(distMeasures));
    res{i} = computeCorrelations(db,frames,distMeasures{i});
    
    if i==1
        if isfield(res{i},'D')
            namesCell = fieldnames(res{i}.D);
            fprintf(fid, '\\textbf{ } ');
            for c=1:2:numel(namesCell)
                id = findstr(namesCell{c},'_');
                name = namesCell{c}(1:id(end)-1);
                name = strrep(name,'_','\_');
                fprintf(fid,' & \\distmeasure{%s}{}',name);
            end
        end
        if isfield(res{i},'F')
            namesCell = fieldnames(res{i}.F);
            for c=1:2:numel(namesCell)
                id = findstr(namesCell{c},'_');
                name = namesCell{c}(1:id(end)-1);
                name = strrep(name,'_','\_');
                fprintf(fid,' & \\featureset{%s}{}',name);
            end
        end
        fprintf(fid,'\\\\\n');
    end
        
    fprintf(fid,'\\distmeasure{%s}{}',distMeasures{i});
    if isfield(res{i},'D')
        distArray = struct2array(res{i}.D);
        for c=1:size(distArray,2)
            fprintf(fid,' & %.2f (%.2f)',distArray(c).rhoCorr,distArray(c).tauCorr);
            D(i,c,1)   = distArray(c).rhoCorr;
            D(i,c,2)   = distArray(c).tauCorr;
        end
    end
    if isfield(res{i},'F')
        featArray = struct2array(res{i}.F);
        for c=1:size(featArray,2)
            fprintf(fid,' & %.2f (%.2f)',featArray(c).rhoCorr,featArray(c).tauCorr);
            D(i,size(distArray,2)+c,1)   = featArray(c).rhoCorr;
            D(i,size(distArray,2)+c,2)   = featArray(c).tauCorr;
        end
    end
    fprintf(fid,'\\\\\n');
    
end

i=size(distMeasures,2);

for j=1:numel(featureSets)
    fprintf('-----------featureSet %s (%i/%i)-----------\n',featureSets{j},j,numel(featureSets));
    res{i+j} = computeCorrelations(db,frames,featureSets{j});
    
    if i+j==1
        if isfield(res{i+j},'D')
            namesCell = fieldnames(res{i+j}.D);
            fprintf(fid, '\\textbf{ } ');
            for c=1:2:numel(namesCell)
                id = findstr(namesCell{c},'_');
                name = namesCell{c}(1:id(end)-1);
                name = strrep(name,'_','\_');
                fprintf(fid,' & \\distmeasure{%s}{}',name);
            end
        end
        if isfield(res{i+j},'F')
            namesCell = fieldnames(res{i+j}.F);
            for c=1:2:numel(namesCell)
                id = findstr(namesCell{c},'_');
                name = namesCell{c}(1:id(end)-1);
                name = strrep(name,'_','\_');
                fprintf(fid,' & \\featureset{%s}{}',name);
            end
        end
        fprintf(fid,'\\\\\n');
    end
    
    fprintf(fid,'\\featureset{%s}{}',featureSets{j});
    if isfield(res{i+j},'D')
        distArray = struct2array(res{i+j}.D);
        for c=1:size(distArray,2)
            fprintf(fid,' & %.2f (%.2f)',distArray(c).rhoCorr,distArray(c).tauCorr);
            D(i+j,c,1)   = distArray(c).rhoCorr;
            D(i+j,c,2)   = distArray(c).tauCorr;
        end
    end
    if isfield(res{i+j},'F')
        featArray = struct2array(res{i+j}.F);
        for c=1:size(featArray,2)
            fprintf(fid,' & %.2f (%.2f)',featArray(c).rhoCorr,featArray(c).tauCorr);
            D(i+j,size(distArray,2)+c,1)   = featArray(c).rhoCorr;
            D(i+j,size(distArray,2)+c,2)   = featArray(c).tauCorr;
        end
    end
    fprintf(fid,'\\\\\n');
end
fprintf(fid,'\\end{tabular}');
fclose(fid);   
clear featArray distArray id name i j c namesCell fid;