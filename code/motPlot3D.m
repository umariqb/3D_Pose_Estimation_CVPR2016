function motPlot3D(inputDB,moData)
%% drawing options
%close all;

pinkish  = [1, 0.6 0.78];     % used for blue arm
brownish = [1, 0.69, 0.39];   % other arm
redk     = 'r';               % blue side wali leg
jamni    = [.48,.06,.89];     % other side wali leg
gr       = 'g';               % used for head to root

%%
allJoints = H_myFormatJoints(inputDB);
jnt.njoints = length(allJoints);
jnt.hd = getSingleJntIdx('Head',allJoints,1);
jnt.nk = getSingleJntIdx('Neck',allJoints,1);
jnt.ls = getSingleJntIdx('Left Shoulder',allJoints,1);
jnt.rs = getSingleJntIdx('Right Shoulder',allJoints,1);
jnt.rh = getSingleJntIdx('Right Hip',allJoints,1);
jnt.lh = getSingleJntIdx('Left Hip',allJoints,1);
jnt.rk = getSingleJntIdx('Right Knee',allJoints,1);
jnt.lk = getSingleJntIdx('Left Knee',allJoints,1);
jnt.ra = getSingleJntIdx('Right Ankle',allJoints,1);
jnt.la = getSingleJntIdx('Left Ankle',allJoints,1);
jnt.re = getSingleJntIdx('Right Elbow',allJoints,1);
jnt.le = getSingleJntIdx('Left Elbow',allJoints,1);
jnt.rw = getSingleJntIdx('Right Wrist',allJoints,1);
jnt.lw = getSingleJntIdx('Left Wrist',allJoints,1);

if(~iscell(moData))
    moData = {moData};
end
%% getting frame no
markSize    = 5;
markFaceCol = 'y';
if(iscell(moData))
    if(isstruct(moData{1}) && isfield(moData{1},'nframes'))  % mot
        nframes = moData{1}.nframes;
        njoints = moData{1}.njoints;
    else
        nframes = size(moData{1},2);
        njoints = size(moData{1},1)/3;
    end
end
%%%for f = 1: nframes
    for mo = 1: size(moData,2)
        if(isstruct(moData{mo}) && isfield(moData{mo},'jointTrajectories'))
            for i = 1:moData{1}.njoints
                x(i) = moData{mo}.jointTrajectories{i}(1,1);
                y(i) = moData{mo}.jointTrajectories{i}(2,1);
                z(i) = moData{mo}.jointTrajectories{i}(3,1);
                plot3(x,y,z,'o','MarkerSize',markSize, 'MarkerEdgeColor','k','MarkerFaceColor',markFaceCol); axis equal
            end
            hold on
            H_drawLineH36M(jnt,x,y,z);
            if(isstruct(moData{mo}) && isfield(moData{mo},'data'))
                plot3(x(jnt.rh:jnt.njoints:end,:),y(jnt.rh:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',jamni);
                hold on
                plot3(x(jnt.rk:jnt.njoints:end,:),y(jnt.rk:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',jamni);
                plot3(x(jnt.ra:jnt.njoints:end,:),y(jnt.ra:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',jamni);
                % left leg
                plot3(x(jnt.lh:jnt.njoints:end,:),y(jnt.lh:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',redk);
                plot3(x(jnt.lk:jnt.njoints:end,:),y(jnt.lk:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',redk);
                plot3(x(jnt.la:jnt.njoints:end,:),y(jnt.la:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',redk);
                % body
                plot3(x(jnt.hd:jnt.njoints:end,:),y(jnt.hd:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',gr);
                plot3(x(jnt.nk:jnt.njoints:end,:),y(jnt.nk:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',gr);
                
                % left arm
                plot3(x(jnt.ls:jnt.njoints:end,:),y(jnt.ls:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',brownish);
                plot3(x(jnt.le:jnt.njoints:end,:),y(jnt.le:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',brownish);
                plot3(x(jnt.lw:jnt.njoints:end,:),y(jnt.lw:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',brownish);
                % right arm
                plot3(x(jnt.rs:jnt.njoints:end,:),y(jnt.rs:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',pinkish);
                plot3(x(jnt.re:jnt.njoints:end,:),y(jnt.re:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',pinkish);
                plot3(x(jnt.rw:jnt.njoints:end,:),y(jnt.rw:jnt.njoints:end,:),z(jnt.rh:jnt.njoints:end,:),'*','MarkerSize',4,'MarkerEdgeColor',pinkish);
            end
        end
        %% axis information
        %set(gca, 'Position',[0.51 0.51 .98 .98]);
        box off;    %
        
        %axis equal
        %axis([-900 900 -1000 1000 -900 900])
        %axis([-1550 1550 -500 2500  -1550 1550]);
        view(0,90);
        camorbit(-5,0,'data',[1 0 0])  % rotating axis 185
        camorbit(25,0,'data',[0 1 0])
        
        camup([0 1 0]);
        cameratoolbar('Show');
        cameratoolbar('SetCoordSys','y');
        cameratoolbar('SetMode','orbit');
        
        drawnow
             
        hold off
        
%%%    end
    
end


