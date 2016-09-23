function [Y,Xf,Af] = RedeNeural(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 05-Sep-2016 14:50:46.
% 
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timsteps
%   Each X{1,ts} = 6xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 2xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

  % ===== NEURAL NETWORK CONSTANTS =====
  
  % Input 1
  x1_step1_xoffset = [0.000522565320665083;0.664734556012531;0.12023397521925;0.855765503875969;98.3453828458758;121.993481435127];
  x1_step1_gain = [5.53142535875738;6.00442236546221;2.27972802141641;13.8914729475305;0.0485253078086986;0.0409323280941659];
  x1_step1_ymin = -1;
  
  % Layer 1
  b1 = [2.091442511662585;-1.5709497594210249;0.58872038954043493;-0.87825652053993508;-1.4985149486789129;0.23090540319402358;-0.45210293339614765;1.5402464496601791;-1.805716723291519;2.0559486281202686];
  IW1_1 = [-1.2069960019216641 -1.2092478209221349 -0.36561171464318332 0.45746004697374781 -0.64708611733280541 -0.66174988430334603;1.1614604358777472 -0.76578700762130525 0.92784499503087503 0.5513559998698413 0.038133752644645448 1.0438157399811545;0.58277042269603019 -0.55677252033570701 0.87968278030740532 -1.018652301160202 1.2748332747008264 -1.1294965645510511;0.48851365257636509 -0.78077599836688028 -0.91809613068972507 -0.87614748219684624 0.73527390567578732 1.3965409664566553;0.60788263062102754 1.9155794778735404 -1.5295388229560236 0.73179798054365364 -0.25958002668472119 0.4355081512540141;0.50746997616122258 0.38220161539019426 0.28425514987341072 1.6832024120599605 0.54012980211002093 -1.4282087333677917;-0.65639535488227785 -1.0195992858806102 1.1207705674682216 -0.48084247087505477 -0.72795196685993979 -1.0588822343085542;0.59936145162279264 0.95779593428553644 1.3240825938683434 0.010637013837484673 -1.3259461045986847 0.42235225423620637;-0.77133338945169294 -1.2565536037196023 0.58460670733786957 -0.93245126981889892 -0.80911711128532826 0.063486666561559865;0.77858675383640552 -0.22693234387057054 -0.84998867953740109 0.94441436420220537 1.2787249933571139 -0.55845624822614848];
  
  % Layer 2
  b2 = [0.62876691538418172;-0.41776774992675852];
  LW2_1 = [0.60190393325659575 0.034402059620709302 -1.1538052238478851 0.60395700195567381 1.8013381688905747 -0.99930145961982175 0.066536715927381931 -1.0069281816124342 -0.22626354351910741 -0.29886978154672966;0.23028150484143378 0.89943248462118985 1.2398837197100747 -0.33560711944796989 -2.5139863083140055 0.16879680297098137 1.3598191127350061 0.40438792030428006 -0.81115103536199806 -0.70252031326902176];
  
  % ===== SIMULATION ========
  
  % Format Input Arguments
  isCellX = iscell(X);
  if ~isCellX, X = {X}; end;
  
  % Dimensions
  TS = size(X,2); % timesteps
  if ~isempty(X)
    Q = size(X{1},2); % samples/series
  else
    Q = 0;
  end
  
  % Allocate Outputs
  Y = cell(1,TS);
  
  % Time loop
  for ts=1:TS
  
    % Input 1
    Xp1 = mapminmax_apply(X{1,ts},x1_step1_gain,x1_step1_xoffset,x1_step1_ymin);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = softmax_apply(repmat(b2,1,Q) + LW2_1*a1);
    
    % Output 1
    Y{1,ts} = a2;
  end
  
  % Final Delay States
  Xf = cell(1,0);
  Af = cell(2,0);
  
  % Format Output Arguments
  if ~isCellX, Y = cell2mat(Y); end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings_gain,settings_xoffset,settings_ymin)
  y = bsxfun(@minus,x,settings_xoffset);
  y = bsxfun(@times,y,settings_gain);
  y = bsxfun(@plus,y,settings_ymin);
end

% Competitive Soft Transfer Function
function a = softmax_apply(n)
  nmax = max(n,[],1);
  n = bsxfun(@minus,n,nmax);
  numer = exp(n);
  denom = sum(numer,1); 
  denom(denom == 0) = 1;
  a = bsxfun(@rdivide,numer,denom);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end