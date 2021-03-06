%% Figure 6 Panel B and C
% Computes and displays the circular dispersion and receptive field offset
% as a function of the distance from the soma
%
% Author: Jan H Kirchner
% email: jan.kirchner@brain.mpg.de
% September 2019;

addpath(genpath('../tools'));
close all
%%
if exist('../data/Figure6PanelBD.mat')
    load('../data/Figure6PanelBD.mat')
else
    % get all simulations with morphology and large receptive field center
    % spread
    fList = rdir('../sims/Fig6/BAP*.mat');
    if isempty( fList )
        fprintf('run batch_process_mouse.m first\n')
    end
    N = 504;

    CIRCDISP = zeros(length(fList) , N); 
    MUDIST = zeros(length(fList) , N); 
    POS = zeros(length(fList) , N); 
    somCONST = zeros(length(fList) , N);
    for xx = 1:length(fList)
        cFile = fList(xx).name
        dat = load(cFile , '-regexp' , '(compSomDist)|(pos)|(subpos)|(thetas)|(MUs)|(somConst)|(muVar)');
        % compute circular dispersion
        thetas =  dat.thetas - pi;
        circ_dist_to_mean = 90*(abs(circ_dist2(thetas , circ_mean(thetas))))/pi ;
        CIRCDISP(xx , :) = circ_dist_to_mean;
        % compute receptive field center offset
        MUDIST(xx , :) = 62.5*sqrt(sum(dat.MUs.^2 , 2))/pi;
        % collect distances from the soma and attenuation constants
        POS(xx , :) = dat.compSomDist(dat.pos) + dat.subpos;
        somCONST(xx , :) = dat.somConst;
    end
end
%%
% plotting
cMAP = cbrewer('seq' , 'Oranges' , 6); cMAP = cMAP(2:end-1 , :);

figure; 
g = gramm('x' , POS(:) , 'y' , CIRCDISP(:) , 'color' , somCONST(:) );
g.stat_summary('bin_in' , 10 , 'geom' , 'area');
g.set_color_options('map' , cMAP);
g.axe_property('PlotBoxAspectRatio' , [1 , 1 , 1] , 'YLim' , [0 , 50] ,...
    'XTick' , [0 , 175 , 350] , 'XLim' , [0 , 350] , 'YTick' , [0 , 15 , 30 , 45]);
g.set_names('x' , 'Distance to soma' , 'y' , 'Circular dispersion');
g.draw;
%%
figure; 
h = gramm('x' , POS(:) , 'y' , MUDIST(:) , 'color' , somCONST(:) );
h.stat_summary('bin_in' , 10 , 'geom' , 'area');
h.set_color_options('map' , cMAP );
h.axe_property('PlotBoxAspectRatio' , [1 , 1 , 1] , 'YLim' , [0 , 25] , ...
    'XTick' , [0 , 175 , 350] , 'XLim' , [0 , 350] , 'YTick' , [0 , 12.5 , 25]);
h.set_names('x' , 'Distance to soma' , 'y' , 'RF center offset');
h.draw;

%%
