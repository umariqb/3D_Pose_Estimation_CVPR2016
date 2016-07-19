function playResultOnClick(obj,event_obj,varargin)

%     fprintf(num2str(nargin));
    Tensor=varargin{1};
    hit=varargin{2};
%     
%     size(hit)
%     size(obj)
%     
%     pos = get(obj,'')
    
    [skel,org,rec]=constructBothMotionsExtraRoot(Tensor,hit);

    motionplayer('skel',[skel skel],'mot',[org rec]);

end

% % 
% % function output_txt = myfunction(obj,event_obj)
% % % Display the position of the data cursor
% % % obj          Currently not used (empty)
% % % event_obj    Handle to event object
% % % output_txt   Data cursor text string (string or cell array of strings).
% % 
% % pos = get(event_obj,'Position');
% % output_txt = {['X: ',num2str(pos(1),4)],...
% %     ['Y: ',num2str(pos(2),4)]};
% % 
% % % If there is a Z-coordinate in the position, display it as well
% % if length(pos) > 2
% %     output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
% % end
