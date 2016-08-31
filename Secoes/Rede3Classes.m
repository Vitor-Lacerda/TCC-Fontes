function [Y,Xf,Af] = Rede3Classes(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 29-Aug-2016 15:12:21.
% 
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timsteps
%   Each X{1,ts} = 8xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 3xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

  % ===== NEURAL NETWORK CONSTANTS =====
  
  % Input 1
  x1_step1_xoffset = [15;64;1.78571428571429;29;85.4541734860884;9;5.53327485189972;1.19497844634338];
  x1_step1_gain = [0.0104712041884817;0.0104712041884817;0.0421414555703825;0.00888888888888889;0.159848623522999;0.00386847195357834;0.0042120726239679;0.0759303762164015];
  x1_step1_ymin = -1;
  
  % Layer 1
  b1 = [2.1347218161245163;-1.518814913065424;-0.74035875660588057;-0.68467904749663344;-0.9941531571046287;0.12693435492823626;-0.65036522265023544;1.1544877478720241;-1.7329669778942653;1.8865525108793022];
  IW1_1 = [-0.57899094272187057 -0.58658281802728018 -0.38075455008011166 0.6994547053619028 -0.46396684070227551 -0.64503593174105245 0.50308148745484638 -0.87359140774374111;0.95216736792159729 -0.7964215273493771 0.78911897797042663 0.2002119930819975 -0.058431101533589234 1.036174890457803 0.37618201102531629 0.042585467951367383;0.95595707763408999 -0.91946902738826664 0.62914374694154063 -0.70438505376275784 0.42191750853427218 -0.76270221667633942 -0.12845000723320035 0.59707983661390418;0.2217160581456829 -0.79660436828583137 -0.4925463915610917 -0.76533212591112854 0.58935977934526806 0.68593356718717735 0.64739704418967503 0.83535132472078499;0.52252843659231951 0.68260392837938333 0.44407062111165985 1.2712005171792418 0.99764767008378641 -0.7853935967031298 -1.2222363785668955 0.61889245744351074;0.88107082946048987 0.75043970046708408 -1.3712488170117088 1.4677839881396617 -0.39163062169746554 0.11476798183354808 1.6283113155903453 0.097252723413593048;-0.35414368196736445 -0.59128414133221696 0.92477211643851076 -0.26479245414177238 -1.1953608318001394 -1.5024932770946786 0.014720982070693747 0.34805439029928531;0.85713045886925698 1.5309128512168806 0.95533944345774457 0.18948296252520855 -0.55852753032655778 0.51828618943588611 -0.13196827302915579 -0.4806760586300915;-1.3367611886563464 -1.678925793486274 0.089542132965316823 -0.98449456050665862 -0.93990909283744606 -0.31642955427760566 0.040943615132503886 -0.39794185068248855;0.49696323836043438 -0.15183271486318553 -0.54680649925234337 0.59653030741798463 0.85444847144103986 -0.34307018830431601 -1.0139509928692609 -0.8325637006883404];
  
  % Layer 2
  b2 = [0.9005078944216669;-0.67516552269359242;-0.51274729321934431];
  LW2_1 = [0.46933419368001889 -0.6815502045955939 -0.17192350299883585 -0.8601690554679402 1.2206435520704202 1.6821156656151439 -0.13752403687780315 -0.99027527431213291 1.4567876158549045 -0.38882933535879555;-0.21129892455862856 0.20431194121050469 0.5010379899421139 0.12107267640593893 -1.8007335822142605 0.59590469614852759 -1.0507151695542329 0.31839651560620907 -1.0814285015020924 0.55172783410247883;0.010030167348458291 -0.46155782573178666 0.8537759019377209 -0.73422373050549983 1.3631547460647209 -2.0527150004834191 1.2106974480542054 0.8655745777039292 -0.66953271440617912 -0.18019307766667067];
  
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