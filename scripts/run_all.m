% Round of simulations started on April/26/2024
%
% Source patch has an effective are of 5 cm^2, never p
% laced on the sulci.
%
%

%% GENERAL PARAMETERS
info = [];

% forward model
%
% Using dipoles at the cortical surface, normal to the cortex. EEG
% electrodes are based on 10-10 system (92 electrodes) over ICBM152.
info.OGforward  = 'asa_10_10_srf_BEM';
info.OGanatomy  = 'icbm152anatomy';
info.SourceType = 'surface';

info.nTrials    = 1;
info.SNRvals    = [inf, 30];

info.ProtocolFun   = 'Protocol04';
info.tagName       = 'vol5k_sizes';

info.maxDepth  = 25; % unit: mm
info.maxKappa  = 10*sqrt(6/pi); % unit: mm
info.minKappa  = 10*sqrt(6/pi); % unit: mm

% for vol:  kap = 30.9 mm  ->  A = 30 cm^2
% for srf:  kap = 30.9 mm  ->  A = 30 cm^2

info.debugFigs  = false;

info.debugCent  = true;
info.debugCoord = [47.353, 18.555, 113.019];

info.print_all = true;

%% CLOSE BROKEN WAITBARS
F = findall(0,'type','figure','tag','TMWWaitbar');
delete(F)

%%
% Source patch has different profiles:
%     square  Unit source over a circle of radius k
%        exp  ||J_n|| = exp( - dist(n, n*) / 2*k )
%      gauss  ||J_n|| = exp( - dist(n, n*)^2 / 2*k^2 )
%       circ  ||J_n|| = sqrt( 1 - [ dist(n, n*) / k ]^2 )

% SQUARE PROFILE
info.BaseName      = [info.tagName, '_gauss'];
info.SourceProfile = 'gauss';
%generator(info);
evaluator(info);
collector(info);

% GAUSSIAN PROFILE
info.BaseName      = [info.tagName, '_exp'];
info.SourceProfile = 'exp';
%generator(info);
evaluator(info);
collector(info);

% EXPONENTIAL PROFILE
info.BaseName      = [info.tagName, '_circ'];
info.SourceProfile = 'circ';
%generator(info);
evaluator(info);
collector(info);

% POLYNOMIAL PROFILE
info.BaseName   = 'protocol04_30_single_circ';
info.SourceProfile = 'circ';
%generator(info);
evaluator(info);
collector(info);

