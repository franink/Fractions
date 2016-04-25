p.flickerFreq   = 6; % Hz
p.flickerPer  = 1/p.flickerFreq; % s

% monitor stuff
p.refreshRate = 60; % refresh rate is normally 100 but change this to 60 when on laptop!
p.vDistCM = 277; %CNI
p.screenWidthCM = 58.6; % CNI
%p.vDistCM = 120; %desktop
%.screenWidthCM = 40; % desktop
p.usedScreenSizeDeg = 12;

%stimulus geometry (in degrees, note that these vars have the phrase 'Deg'
%in them, used by pix2deg below)
p.radDeg = p.usedScreenSizeDeg/8; %edge of stim touches borders of screen
p.sfDeg = .6785; %TS parameter value, might need to be changed

p.backColor     = [128, 128, 128];      % background color

%fixation point properties
p.fixColor      = [250, 1, 1];%[155, 155, 155];
% p.fixSizeDeg    = .25 * .4523;                  % size of dot
p.fixSizeDeg    = .1131;
p.appSizeDeg    = p.fixSizeDeg * 4;     % size of apperture surrounding dot

% font stuff
p.fontSize = 40;    
p.fontName = 'HELVETICA';   
p.textColor = [255, 255, 255];

% --------------------Screen properties----------------------------%

p.LUT = 0:255;
% correct all the colors
p.fixColor = p.LUT(p.fixColor)';
p.textColor = p.LUT(p.textColor)';

%% After initializing screen window%%

% Enable alpha blending with proper blend-function. We need it
% for drawing of smoothed points:
Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% test the refesh properties of the display
p.fps=Screen('FrameRate',win);          % frames per second
p.ifi=Screen('GetFlipInterval', win);   % inter-frame-time
if p.fps==0                           % if fps does not register, then set the fps based on ifi
    p.fps=1/p.ifi;
end
p.flickerFrames = round(1/p.flickerFreq*p.fps);

% make sure the refreshrate is ok
if abs(p.fps-p.refreshRate)>5
    Screen('CloseAll');
    disp('CHANGE YOUR REFRESH RATE')
    ListenChar(0);
    clear all;
    return;
end

% convert relevant timing stuff to vid frames for stim presentation
p.stimExpose = round((p.stim_t*1000)./(1000/p.refreshRate)); %p.stim_t needs to changed for the purposes of this experiment

% set the priority up way high to discourage interruptions
Priority(MaxPriority(win));

% convert from degrees to pixel units
p = deg2pix(p);


% generate checkerboards we use...
p.stimContrast = 1;
c = make_checkerboard(p.radPix,p.sfPix,p.stimContrast);
%c{1}
stim(1)=Screen('MakeTexture', win, c{1});
stim(2)=Screen('MakeTexture', win, 127*ones(size(c{2})));
stim(3)=Screen('MakeTexture', win, c{2});
%stim(3)
        
p.flickerSequ = repmat([ones(1,round(p.flickerFrames/2)) 2*ones(1,round(p.flickerFrames/2)) 3*ones(1,round(p.flickerFrames/2)) 2*ones(1,round(p.flickerFrames/2))],1,(0.5)*round(p.stimExpose/p.flickerFrames));

