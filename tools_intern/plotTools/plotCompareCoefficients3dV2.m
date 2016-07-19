function plotCompareCoefficients3dV2(Xn,T,varargin)

switch nargin
    case 2
        debug=false;
    case 3
        debug=varargin{1};
    otherwise
        fprintf('plotCompareCoefficients3dV2: Wrong number of arguments\n');
end

numClasses=size(Xn,1);


if debug
    fprintf('numClasses=%i\n',numClasses);
end

for Class=1:numClasses
    fig_hand=figure;
    hold all;
    subPlotCounter=1;
    maxHits=size(Xn,2);
    maxModes=T.numNaturalModes;
    
    subplot(maxHits,maxModes,1);
    
    if debug
        fprintf('maxHits=%i\n',maxHits);
    end
    
    for Hit=1:maxHits
        modes=T.numNaturalModes;
        if debug
            fprintf('modes=%i\n',modes);
        end
        
        for mode=1:modes
            if debug
                fprintf('mode=%i Hit=%i\n',mode,Hit);
            end
            subplot(maxHits,maxModes,subPlotCounter);
            subPlotCounter=subPlotCounter+1;
            
            if(~isempty(Xn{Class,Hit}))
                bar(Xn{Class,Hit}.coeffsX{mode});
           
            
                switch mode
                case 1
                    xlabel('Styles')
                    set(gca,'XTickLabel',T.styles,'FontSize',8);
                case 2
                    t_handle = title([Xn{Class,Hit}.origMot.filename],'Interpreter','none');
                    
                    motions.mot1 = Xn{Class,Hit}.origMot;
                    motions.mot2 = Xn{Class,Hit}.recMotUnwarped;
                    motions.skel = Xn{Class,Hit}.skel;
                    
                    set(t_handle, 'buttondownfcn',{@motionPlayOnClick,motions});
%                            , ...
%                                (Xn{Class,Hit}.startFrame-1) * 4 + 1, ...
%                                (Xn{Class,Hit}.endFrame-1)*4+1});                    
                            
                            
                    xlabel('Actors')
                    set(gca,'XTickLabel',{'1','2','3','4','5'});
                case 3
                    xlabel('Repetition')
                    set(gca,'XTickLabel',{'First','Second','Third'});
                otherwise
                    error('Something is strange!');
                end    
            end
        end
    end
    

end