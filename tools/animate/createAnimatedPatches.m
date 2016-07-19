function patches = createAnimatedPatches(k,current_frame,varargin)

global VARS_GLOBAL_ANIM

patches = [];
for j=1:length(VARS_GLOBAL_ANIM.mot(k).animated_patch_data)
    function_handle = str2func(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).function_name);
    switch (lower(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).type))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
        case 'disc'
            
            function_params = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).function_params;
            [points,normals,min_radius] = feval(function_handle,...
                                                VARS_GLOBAL_ANIM.mot(k),...
                                                function_params{:});
		    %%
            if (length(function_params)>=6)
                offset = function_params{6};
            else
                offset = [0;0;0];
            end
            
            npoints = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).nsteps + 1;
            X = zeros(npoints,VARS_GLOBAL_ANIM.mot(k).nframes);                                    
            Y = zeros(npoints,VARS_GLOBAL_ANIM.mot(k).nframes);                                    
            Z = zeros(npoints,VARS_GLOBAL_ANIM.mot(k).nframes);                                    
            for i=1:VARS_GLOBAL_ANIM.mot(k).nframes
                [X(1:npoints,i),Y(1:npoints,i),Z(1:npoints,i)] = coordsDiscNormal(normals(:,i), points(:,i), 1.1*min_radius(i), VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).nsteps, offset);
            end
%             X(npoints+1,:) = points(1,:)+offset(1);
%             Y(npoints+1,:) = points(2,:)+offset(2);
%             Z(npoints+1,:) = points(3,:)+offset(3);
            
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).X = X;
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).Y = Y;
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).Z = Z;
           
            if (isempty(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color))
                VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color = [0 0 0];
            end
            if (size(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color,1)==1)
                C = repmat(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color,size(Z,1),1);
            else
                C = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color;
            end
            faces = [npoints*ones(npoints-1,1) [1:npoints-1]' mod([1:npoints-1],npoints-1)'+1];
            h = patch('Vertices',[X(:,current_frame) Y(:,current_frame) Z(:,current_frame)],...
                      'Faces',faces,...
                      'FaceVertexCData',C,...
                      'FaceColor','flat',...
                      'EdgeColor','none',...
                      'FaceLighting','none');
            alpha(h,VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).alpha);
            patches = [patches h];

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
        case 'polygondisc'
            
            function_params = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).function_params;
            [points,normals,min_radius] = feval(function_handle,...
                                                VARS_GLOBAL_ANIM.mot(k),...
                                                function_params{:});
		    %%
            if (length(function_params)>=6)
                offset = function_params{6};
            else
                offset = [0;0;0];
            end
            
            npoints = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).nsteps + 1;
            X = zeros(npoints,VARS_GLOBAL_ANIM.mot(k).nframes);                                    
            Y = zeros(npoints,VARS_GLOBAL_ANIM.mot(k).nframes);                                    
            Z = zeros(npoints,VARS_GLOBAL_ANIM.mot(k).nframes);                                    
            for i=1:VARS_GLOBAL_ANIM.mot(k).nframes
                [X(1:npoints,i),Y(1:npoints,i),Z(1:npoints,i)] = coordsDiscNormal(normals(:,i), points(:,i), 1.1*min_radius(i), VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).nsteps, offset);
            end
            X = X(1:npoints-1,:); % get rid of midpoint
            Y = Y(1:npoints-1,:);
            Z = Z(1:npoints-1,:);
            
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).X = X;
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).Y = Y;
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).Z = Z;
           
            if (isempty(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color))
                VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color = [0 0 0];
            end
            if (size(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color,1)==1)
                C = repmat(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color,size(Z,1),1);
            else
                C = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color;
            end
            faces = [1:npoints-1];
            h = patch('Vertices',[X(:,current_frame) Y(:,current_frame) Z(:,current_frame)],...
                      'Faces',faces,...
                      'FaceVertexCData',C,...
                      'FaceColor','flat',...
                      'EdgeColor','none',...
                      'FaceLighting','none');
            alpha(h,VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).alpha);
            patches = [patches h];

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
        case 'griddisc'
            
            function_params = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).function_params;
            [points,normals,min_radius] = feval(function_handle,...
                                                VARS_GLOBAL_ANIM.mot(k),...
                                                function_params{:});
		    %%
            if (length(function_params)>=6)
                offset = function_params{6};
            else
                offset = [0;0;0];
            end
            
            nsteps = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).nsteps;
            nlatitude = ceil(nsteps/2);
            npoints = nlatitude*nsteps+1;
            X = zeros(npoints,VARS_GLOBAL_ANIM.mot(k).nframes);                                    
            Y = zeros(npoints,VARS_GLOBAL_ANIM.mot(k).nframes);                                    
            Z = zeros(npoints,VARS_GLOBAL_ANIM.mot(k).nframes);                                    
            for i=1:VARS_GLOBAL_ANIM.mot(k).nframes
                [X(1:npoints,i),Y(1:npoints,i),Z(1:npoints,i)] = coordsGridDiscNormal(normals(:,i), points(:,i), 1.1*min_radius(i), nsteps, nlatitude, offset);
            end
            
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).X = X;
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).Y = Y;
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).Z = Z;
           
            if (isempty(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color))
                VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color = [0 0 0];
            end
            if (size(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color,1)==1)
                C = repmat(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color,size(Z,1),1);
            else
                C = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color;
            end

            faces = zeros(nsteps*nlatitude,4);
            W = [[1:nsteps]' circshift([1:nsteps]',-1) circshift([nsteps+1:2*nsteps]',-1) [nsteps+1:2*nsteps]'];
            o = 1;
            for i=1:nlatitude-1
                faces(o:o+nsteps-1,:) = W + (i-1)*nsteps;
                o = o + nsteps;
            end
            faces(o:o+nsteps-1,:) = [[(nlatitude-1)*nsteps+1:nlatitude*nsteps]' circshift([(nlatitude-1)*nsteps+1:nlatitude*nsteps]',-1) (nsteps*nlatitude+1)*ones(nsteps,1) [(nlatitude-1)*nsteps+1:nlatitude*nsteps]'];
            
            h = patch('Vertices',[X(:,current_frame) Y(:,current_frame) Z(:,current_frame)],...
                      'Faces',faces,...
                      'FaceVertexCData',C,...
                      'FaceColor','flat',...
                      'EdgeColor','none',...
                      'FaceLighting','none');
            alpha(h,VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).alpha);
            patches = [patches h];

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
        case 'point'
            
            points = feval(function_handle,...
                           VARS_GLOBAL_ANIM.mot(k),...
                           VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).function_params{:});
		
            X = points(1,:);
            Y = points(2,:);
            Z = points(3,:);
            
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).X = X;
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).Y = Y;
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).Z = Z;
           
            if (isempty(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color))
                VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color = [0 0 0];
            end
            if (size(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color,1)==1)
                C = repmat(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color,size(Z,1),1);
            else
                C = repmat(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color(current_frame,:),size(Z,1),1);
            end
            if isempty(VARS_GLOBAL_ANIM.animated_point_MarkerEdgeColor)
                markeredgecolor = C;
            else
                markeredgecolor = repmat(VARS_GLOBAL_ANIM.animated_point_MarkerEdgeColor,size(Z,1),1);
            end

            faces = [1];
            
            h = patch('Vertices',[X(:,current_frame) Y(:,current_frame) Z(:,current_frame)],...
                      'Faces',faces,...
                      'MarkerEdgeColor',markeredgecolor,...
                      'MarkerFaceColor',C,...
                      'Marker',VARS_GLOBAL_ANIM.animated_point_Marker,...
                      'MarkerSize',VARS_GLOBAL_ANIM.animated_point_MarkerSize);
            alpha(h,VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).alpha);
            patches = [patches h];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
        case 'cappedcylinder'
            
            [points1,points2] = feval(function_handle,...
                                                VARS_GLOBAL_ANIM.mot(k),...
                                                VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).function_params{:});
		
            if (length(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).function_params)>=4)
                use_caps = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).function_params{4};
            else
                use_caps = [true true];
            end
            if (length(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).function_params)>=3)
                epsilon = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).function_params{3};
            else
                error('Expected epsilon parameter.');
            end
            nsteps = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).nsteps;
            nlatitude = ceil(nsteps/2);
            npoints = 2*(nsteps + (nlatitude-1)*nsteps+1);

            for i=1:VARS_GLOBAL_ANIM.mot(k).nframes
                [X(:,i),Y(:,i),Z(:,i)] = coordsCappedCylinder(points1(:,i), points2(:,i), epsilon, nsteps, use_caps);
            end
            
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).X = X;
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).Y = Y;
            VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).Z = Z;
           
            if (isempty(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color))
                VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color = [0 0 0];
            end
            if (size(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color,1)==1)
                C = repmat(VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color,size(Z,1),1);
            else
                C = VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).color;
            end
            
            faces = zeros(nsteps*(1+2*nlatitude),4);
            faces(1:nsteps,:) = [[1:nsteps]' [nsteps*nlatitude+2:nsteps*(1+nlatitude)+1]' circshift([nsteps*nlatitude+2:nsteps*(1+nlatitude)+1]',-1) circshift([1:nsteps]',-1)];
            W = [[1:nsteps]' circshift([1:nsteps]',-1) circshift([nsteps+1:2*nsteps]',-1) [nsteps+1:2*nsteps]'];
            o = nsteps+1;
            for i=1:nlatitude-1
                faces(o:o+nsteps-1,:) = W + (i-1)*nsteps;
                o = o + nsteps;
            end
            faces(o:o+nsteps-1,:) = [[(nlatitude-1)*nsteps+1:nlatitude*nsteps]' circshift([(nlatitude-1)*nsteps+1:nlatitude*nsteps]',-1) (nsteps*nlatitude+1)*ones(nsteps,1) [(nlatitude-1)*nsteps+1:nlatitude*nsteps]'];
            o = o + nsteps;
            W = fliplr(W); % to get the normals pointing outwards
            for i=1:nlatitude-1
                faces(o:o+nsteps-1,:) = W + (i-1)*nsteps + nsteps*nlatitude+1;
                o = o + nsteps;
            end
            faces(o:o+nsteps-1,:) = fliplr([[(nlatitude-1)*nsteps+ nsteps*nlatitude+2:nlatitude*nsteps+ nsteps*nlatitude+1]' circshift([(nlatitude-1)*nsteps+ nsteps*nlatitude+2:nlatitude*nsteps+ nsteps*nlatitude+1]',-1) npoints*ones(nsteps,1) [(nlatitude-1)*nsteps+ nsteps*nlatitude+2:nlatitude*nsteps+ nsteps*nlatitude+1]']);
            o = o + nsteps;
            
            h = patch('Vertices',[X(:,current_frame) Y(:,current_frame) Z(:,current_frame)],...
                      'Faces',faces,...
                      'FaceVertexCData',C,...
                      'FaceColor','flat',...
                      'EdgeColor','none',...
                      'FaceLighting','Phong');
            alpha(h,VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).alpha);
            patches = [patches h];
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
        otherwise
            warning(['Unknown patch type ' VARS_GLOBAL_ANIM.mot(k).animated_patch_data(j).type]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
    end
end