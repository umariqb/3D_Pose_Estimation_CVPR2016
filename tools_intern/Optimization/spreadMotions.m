function [skel,mot,d]=spreadMotions(SKEL,mot1,mot2,varargin)

dist=50;

z=-dist;
x=0;
mot{1}=fitMotion(SKEL,mot1);
mot{1}=convert2euler(SKEL,mot{1});
skel{1}=SKEL;
% d{1,1}=compareMotions_jt(removeTranslation(mot{1}),removeTranslation(mot{1}));
% d{1,2}=mean(d{1,1}(joints));
mot{2}=fitMotion(SKEL,mot2);
skel{2}=SKEL;
% d{2,1}=compareMotions_jt(removeTranslation(mot{1}),removeTranslation(mot{2}));
mot{2}=translateMotion(SKEL,mot{2},x,0,z);
mot{2}=convert2euler(SKEL,mot{2});
% d{2,2}=mean(d{2,1}(joints));

MARKER=[];
motcounter=2;
for i=1:nargin-3
    if isstruct(varargin{i})
        motcounter=motcounter+1;
        mot{motcounter}=varargin{i};
    else
        MARKER=varargin{i};
    end
end

counter=0;
m=0;
if ~isempty(MARKER)
    m=1;
    for j=MARKER
        counter=counter+1;
        marker{counter}.size=2;
        marker{counter}.color=[1 0 0];
        marker{counter}.stream=mot{1}.jointTrajectories{j}+repmat([0,0,z]',1,length(mot{1}.jointTrajectories{j}));
    end
end

count=2;
for i=3:nargin-1-m
    z=z-dist;
    if mod(count,5)==0
        x=x-dist;
        z=0;
    end
    count=count+1;
    
    mot{i}=fitMotion(SKEL,mot{i});
    mot{i}=convert2euler(SKEL,mot{i});
%     d{i,1}=compareMotions_jt(removeTranslation(mot{1}),removeTranslation(mot{i}));
%     d{i,2}=mean(d{i,1}(joints));
    mot{i}=translateMotion(SKEL,mot{i},x,0,z);
    if ~isempty(MARKER)
        for j=MARKER
            counter=counter+1;
            marker{counter}.size=2;
            marker{counter}.color=[1 0 0];
            marker{counter}.stream=mot{1}.jointTrajectories{j}+repmat([0,0,z]',1,length(mot{1}.jointTrajectories{j}));
        end
    end
    skel{i}=SKEL;
end

if ~isempty(MARKER)
    motionplayer('skel',skel,'mot',mot,'marker',marker);
else
    motionplayer('skel',skel,'mot',mot);
end