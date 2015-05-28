% 295 s - 131 TRs @ 2.25 sec/TR (per attn/spatial condition)

function map2dAttn_flicker4 

% map2d_delay Localizer - identical to map2dAttn_flicker3, but units are
% correct (all multiiplied by .4523), and no stim/fix dimming
% - and probe (T2) color is green, for consistency with map2d_delay &
%   map2d_localizer

% TCS - 7/31/12

% NOTE: I'm changing as little as possible, so these *could* still work,
% but you will not have expected results!!!!

% show flickering checkerboards at different locations on screen.
% 3 different conditions tested:
% - 1: attend fixation, detect contrast dimming (either button) on some
%   trials
% - 2: attend checkerboards, detect contrast dimming on some trials
% - 3: spatial working memory - were target and probe presented at same
%   location? (left = same, right = different)
% 
% this will be used for 2d mapping of spatial responses in early regions

% TR counting updated 12/11/12 to account for multiple triggers on 3TE
% (waits TR/2 sec now instead of TR/10)

% TODO:
% - add staircasing!


%addpath('../parallel_tools');

%% get user input about sub name etc...

mygreen = [0 165 0];
myred   = [255 0 0];

warning('off','MATLAB:dispatcher:InexactMatch');
%Screen('Preference', 'SkipSyncTests', 1)
%get subject info
prompt = {'Subject Name','Condition (1 = fix, 2 = checkerboards, 3 = working memory)','Staggered (-1 or 1)?', 'Block number', 'Random seed', 'fMRI','Eye tracking','WM Distance'};
%grab a random number and seed the generator (include this as a gui field
%in case we want to repeat an exact sequence)
s = round(sum(100*clock));
%put in some default answers
defAns = {'AB51','3','1','1',num2str(s),'1','0','0.7'};
box = inputdlg(prompt,'Enter Subject Information...', 1, defAns);

p.exptName = 'map2dAttnFlicker';

if length(box)==length(defAns)
    p.subName=char(box{1});
    p.sessionNum=1;%str2num(box{2});
    p.cond = str2num(box{2});
    p.staggered = str2num(box{3});
    p.nBlocks=eval(box{4});
    p.rndSeed=str2num(box{5});
    p.fMRI=str2num(box{6});
    p.eyeTracking = str2num(box{7});
    p.fixContrastChange = 0.5;%str2num(box{8});
    p.stimContrastChange = 0.5;%str2num(box{9});
    p.wmDifficulty = str2num(box{8}); % WM difficulty is how far, in radians from center of stim, targ & probe are apart (multiples of pi/2)
    rand('state',p.rndSeed);  %actually seed the random number generator
else
    return
end

%p.keys = 66; %keys that correspond to elements in p.dir respectively (B)

if p.eyeTracking
    disp('setting up eyetracking...');
    try
        write_parallel(0); % initial communication w/ eyetracker?
    catch thisError
        disp('EyeTracking error...continuing with p.eyeTracking = 0;');
        disp(thisError);
        p.eyeTracking = 0;
        p.eyeTrackingStopped = 'at setup';
    end
end

%% --------------------begin user define parameters----------------------------%

% Screen (parameter) setup
p.windowed = ~p.fMRI;                     % if 1 then the display will be in a small window, use this for debugging.

% monitor stuff
p.refreshRate = 60;                 % refresh rate is normally 100 but change this to 60 when on laptop!
if p.fMRI
    p.vDistCM = 375; % CM
    p.screenWidthCM = 105; % CM
else
    p.vDistCM = 60;
    p.screenWidthCM = 32;
end
%p.usedScreenSizeDeg = 18; % about 4 deg on each side...
%p.usedScreenSizeDeg = (8/7) * 18 * .4523;
p.usedScreenSizeDeg = 9.3045;

p.nLoc = 6; % stim will appear at random location on nLoc by nLoc grid (should be even)

%stimulus geometry (in degrees, note that these vars have the phrase 'Deg'
%in them, used by pix2deg below)
p.radDeg = p.usedScreenSizeDeg/(p.nLoc+2);
%p.sfDeg  = 1.5 * .4532;
p.sfDeg = .6785;
p.targetProbeSepDistance = pi/2 * p.wmDifficulty; % radians (WM)
p.targetProbeMinRadDeg = p.radDeg*(1/5); % must have eccentricity of this or GREATER... TCS 11/13/12
p.targetProbeMaxRadDeg = p.radDeg*(4/5); % ...and this or SMALLER TCS 11/13/12

% font stuff
p.fontSize = 24;    
p.fontName = 'ARIAL';   
p.textColor = [100, 100, 100];  

%Response keys
if ismac
    p.escape = 41;
else
    p.escape = 27;
end
p.keys = [KbName('b'),KbName('y')]; % 1 and 2 keys
p.space = KbName('space');
p.start = KbName('t');

p.backColor     = [128, 128, 128];      % background color

%fixation point properties
p.fixColor      = [180 180 180];%[155, 155, 155];
% p.fixSizeDeg    = .25 * .4523;                  % size of dot
p.fixSizeDeg    = .1131;
p.appSizeDeg    = p.fixSizeDeg * 4;     % size of apperture surrounding dot

% target/probe properties (WM)
% target/probe properties (WM) ( both 0.5 - now 0.5 * .4523)
p.targetSizeDeg = 0.2262;
p.probeSizeDeg = 0.2262;

p.wmTargetColor = myred;
p.wmProbeColor  = mygreen;

% target properties (fix/checks)
p.stimContrast = 1;
%p.contrastChange = 0.5; % will change by this*100% difference from bg color
p.targetContrast = p.stimContrast - p.stimContrastChange;
p.targetFixColor = p.backColor + (abs(p.fixColor - p.backColor)) * (1-p.fixContrastChange);

% trial setup
p.percentNull = 0.2;
p.repetitions = 1; 
if p.windowed % DEBUG MODE
    p.repetitions = 1;
end
p.nTrials = p.repetitions * p.nLoc * p.nLoc * length(p.cond);    % length p.cond, for now, should always be 1
p.numNullTrials = ((1/(1-p.percentNull)) - 1) * p.nTrials;
p.nTrials = p.nTrials + p.numNullTrials; % no stim

% stimulus timing (in seconds - convert to vid frames, if necessary, later)
p.stimExposeDur = 3; % keep this constant
p.wmTargetDur   = 0.5; % s
p.wmProbeDur    = 0.5; % s
p.flickerFreq   = 6; % Hz
p.flickerPer  = 1/p.flickerFreq; % s
p.contrastChangeWindow = [0.5 p.stimExposeDur-0.75]; % period over which contrast can change
p.minTargFrame = p.contrastChangeWindow(1)*p.flickerFreq + 1; % these are period index (which period can we start target?)
p.maxTargFrame = p.contrastChangeWindow(2)*p.flickerFreq + 1; % +1 is because want cycle *starting at* this point in time
p.responseWindow = 1.0;
p.nTargs = 1;
p.minTargSep = 1; % number of periods
% time between stimulus presentations, constant
p.ITI           = 2.0 * ones(p.nTrials,1);
p.trialDur      = p.wmTargetDur + p.stimExposeDur + p.wmProbeDur + p.ITI;
p.nTRsWait      = 5;
p.startWait     = 2;
p.passiveDur    = 10; % in sec, how long to wait at end of a block (and beginning?)
p.TR            = 2.25;
p.expDur        = sum(p.trialDur) + p.passiveDur + p.startWait + p.nTRsWait*p.TR;

disp(sprintf('SCAN DURATION: %i',p.expDur));
disp(sprintf('# TRs: %i',ceil(p.expDur/p.TR)));
 
ListenChar(2);

%% --------------------Screen properties----------------------------%

p.LUT = 0:255;
% correct all the colors
p.fixColor = p.LUT(p.fixColor)';
p.targetFixColor = p.LUT(round(p.targetFixColor))';
p.textColor = p.LUT(p.textColor)';
p.backColor = p.LUT(p.backColor)';

%Start setting up the display
AssertOpenGL; % bail if current version of PTB does not use

% Open a screen
Screen('Preference','VBLTimestampingMode',-1);  % for the moment, must disable high-precision timer on Win apps

% figure out how many screens we have and pick the last one in the list
s=max(Screen('Screens'));
p.black = BlackIndex(s);
p.white = WhiteIndex(s);

if p.windowed
    Screen('Preference', 'SkipSyncTests', 1);
    [w p.sRect]=Screen('OpenWindow', s, p.backColor, [50,50,800,600]);
else
    [w p.sRect]=Screen('OpenWindow', s, p.backColor);
    HideCursor;
end

% Enable alpha blending with proper blend-function. We need it
% for drawing of smoothed points:
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% test the refesh properties of the display
p.fps=Screen('FrameRate',w);          % frames per second
p.ifi=Screen('GetFlipInterval', w);   % inter-frame-time
if p.fps==0                           % if fps does not register, then set the fps based on ifi
    p.fps=1/p.ifi;
end
p.flickerFrames = 1/p.flickerFreq*p.fps;

% make sure the refreshrate is ok
if abs(p.fps-p.refreshRate)>5
    Screen('CloseAll');
    disp('CHANGE YOUR REFRESH RATE')
    ListenChar(0);
    clear all;
    return;
end

% convert relevant timing stuff to vid frames for stim presentation
p.stimExpose = round((p.stimExposeDur*1000)./(1000/p.refreshRate));

% if running the real experiment (not debugging), then hide cursor and set
% priority high
if ~p.windowed
    HideCursor; % Hide the mouse cursor
    % set the priority up way high to discourage interruptions
    Priority(MaxPriority(w));
end

% convert from degrees to pixel units
p = deg2pix(p);

% now we have p.usedScreenSizePix, p.radPix

% compute and store the center of the screen: p.sRect contains the upper
% left coordinates (x,y) and the lower right coordinates (x,y)
center = [(p.sRect(3) - p.sRect(1))/2, (p.sRect(4) - p.sRect(2))/2];

p.xOffsetPix = 0;
left = [center(1)-p.xOffsetPix, center(2)];

Screen('TextSize', w, p.fontSize);
Screen('TextStyle', w, 1);
Screen('TextFont',w, p.fontName);
Screen('TextColor', w, p.textColor);

% file/directory operations
p.root = pwd;

if ~isdir([p.root '/Subject Data/'])
    mkdir([p.root '/Subject Data/']);
end
p.subNameAndDate = [p.subName '_' datestr(now,30)];

%% start a block loop
for b=p.nBlocks

    fName=[p.root, '/Subject Data/', p.exptName, num2str(p.cond),'_', p.subNameAndDate, '_sess', num2str(p.sessionNum), '_blkNum', num2str(b), '.mat'];
    if exist(fName,'file')
        Screen('CloseAll');
        msgbox('File name already exists, please specify another', 'modal')
        ListenChar(0);
        return;
    end
    
    % open eyetracker file
    if p.eyeTracking
        try
            write_parallel(64); % open file             
            disp('ET started');
        catch thisError
            disp('Error during file opening');
            p.eyeTracking = 0;
            p.eyeTrackingStopped = 'After 64';
            disp(thisError);
        end
    end
    
    [p.stimLocsX p.stimLocsY] = meshgrid(1:p.nLoc);
    p.stimLocsX = reshape(p.stimLocsX,numel(p.stimLocsX),1);
    p.stimLocsY = reshape(p.stimLocsY,numel(p.stimLocsY),1);
    
    % choose which trials to dim fixation, stimulus
    p.dimStim = Shuffle([ones(length(p.stimLocsX)/2,1); zeros(length(p.stimLocsX)/2,1)]);
    p.dimFix  = Shuffle([ones(length(p.stimLocsX)/2,1); zeros(length(p.stimLocsX)/2,1)]);
    
    % mark null trials
    p.stimLocsX(end+1:p.nTrials) = NaN;
    p.stimLocsY(end+1:p.nTrials) = NaN;
    p.null = zeros(p.nTrials,1); p.null(isnan(p.stimLocsX)) = 1;
    p.dimStim(end+1:p.nTrials) = 0;
    p.dimFix(end+1:p.nTrials) = 0;
    
    % updated TCS 11/13/12 - fix max/min...
    % choose which trials are same/different target/probe location
    p.targetProbeMatch = [zeros(floor(p.nTrials/2),1); ones(ceil(p.nTrials/2),1)]; % if floor/ceil used reliably together, should always come out same... ( sum = p.nTrials)
    %p.targetLoc(:,1) =  p.targetProbeMinRadPix + round((p.radPix - p.targetProbeMaxRadPix - p.targetProbeMinRadPix)*rand(p.nTrials,1)); % pick radii
    p.targetLoc(:,1) =  p.targetProbeMinRadPix + round((p.targetProbeMaxRadPix - p.targetProbeMinRadPix)*rand(p.nTrials,1)); % pick radii
    p.targetLoc(:,2) = [linspace(0,2*pi,floor(p.nTrials/2))'; linspace(0,2*pi,ceil(p.nTrials/2))'];
    %p.probeLoc(:,1) =  p.targetProbeMinRadPix + round((p.radPix - p.targetProbeMaxRadPix - p.targetProbeMinRadPix)*rand(p.nTrials,1));  % pick radii
    p.probeLoc(:,1) =  p.targetProbeMinRadPix + round((p.targetProbeMaxRadPix - p.targetProbeMinRadPix)*rand(p.nTrials,1));  % pick radii
    p.probeLoc(p.targetProbeMatch==1,1) = p.targetLoc(p.targetProbeMatch==1,1);
    p.probeLoc(p.targetProbeMatch==1,2) = p.targetLoc(p.targetProbeMatch==1,2);
    misMatch = p.targetProbeMatch == 0;
    %p.probeLoc(misMatch,1) =  p.targetProbeMinRadPix + round((p.radPix - 5 - p.targetProbeMinRadPix)*rand(sum(misMatch),1));  % pick radii
    %p.probeLoc(misMatch,1) =  p.targetProbeMinRadPix + round((p.radPix - 5 - p.targetProbeMinRadPix)*rand(sum(misMatch),1));  % pick radii
    p.probeLoc(misMatch,2) = p.targetLoc(misMatch,2) + linspace(p.targetProbeSepDistance, 2*pi - p.targetProbeSepDistance,sum(misMatch))';
    clear misMatch;
    
    % shuffle trial order
    p.rndInd = randperm(p.nTrials);
    p.stimLocsX = p.stimLocsX(p.rndInd);
    p.stimLocsY = p.stimLocsY(p.rndInd);
    p.null = p.null(p.rndInd);
    p.dimStim = p.dimStim(p.rndInd);
    p.dimFix = p.dimFix(p.rndInd);
    p.rndIndWM = randperm(p.nTrials); % different random indices for working memory targets (so no wm/location correspondence)
    p.targetProbeMatch = p.targetProbeMatch(p.rndIndWM);
    p.targetLoc = p.targetLoc(p.rndIndWM,:);
    p.probeLoc = p.probeLoc(p.rndIndWM,:);
        
    %allocate some arrays for storing the subject response
    p.hits =        0;
    p.misses =      0;
    p.falseAlarms = 0;
    p.correctRejections = 0; % sum of these by end of expt = p.nTrials
    p.rt =          nan(1, p.nTrials);       % store the rt on each trial
    p.resp =        zeros(p.nTrials, p.stimExpose);     % store the response
    p.wmResp =      zeros(p.nTrials,1);
    p.wmCorrect =   0;
    p.wmIncorrect = 0;
    p.trialStart =  nan(p.nTrials,1);    % equal to targetStart
    p.trialEnd =  nan(p.nTrials,1);
    p.stimStart =  nan(p.nTrials,1);
    p.stimEnd =  nan(p.nTrials,1);
    
    % generate checkerboards we use...
    c = make_checkerboard(p.radPix,p.sfPix,p.stimContrast);
    stim(1)=Screen('MakeTexture', w, c{1});
    stim(2)=Screen('MakeTexture', w, 127*ones(size(c{2})));
    stim(3)=Screen('MakeTexture', w, c{2});
    t = make_checkerboard(p.radPix,p.sfPix,p.targetContrast);
    dimStim(1)=Screen('MakeTexture', w, t{1});
    dimStim(2)=stim(2);
    dimStim(3)=Screen('MakeTexture', w, t{2});
    
    % generate a distribution for choosing the target time
    % ANNA's WAY: nStims = (p.stimExpose/p.refreshRate)*((p.refreshRate/p.flickerFreq)/2); % gives number of stim, but at refreshRate/flickerFreq rate, in Hz (so, if flickerFreq is 6, this is 5 Hz)
    nStims = (p.stimExpose/p.refreshRate)*(p.flickerFreq ); % nStims = # periods to show (# of stim1/stim2 or targ1/targ2 alternations)
    p.targX = p.minTargFrame:p.minTargSep:p.maxTargFrame;   % this will be used to select when to show target(s) 
    for ii=1:p.nTrials
        tmp = randperm(length(p.targX));
        %p.targFrame(ii,:) = sort(p.targX(tmp(1:p.nTargs)))*(p.flickerFreq*2)-(p.flickerFreq*2)+1;
        p.targFrame(ii,:) = sort(p.targX(tmp(1:p.nTargs)))*(p.flickerFrames) - p.flickerFrames+1;
        p.targOnTime(ii,:) = p.targFrame(ii,:).*(1/p.refreshRate);
        p.targMaxRespTime(ii,:) = (p.targFrame(ii,:).*(1/p.refreshRate))+p.responseWindow;
    end
    
    % pick the stimulus sequence for every trial (the exact grating to be shown)
    for i=1:p.nTrials
        p.flickerSequ = repmat([ones(1,p.flickerFrames/2) 2*ones(1,p.flickerFrames/2)],1,p.stimExpose/p.flickerFrames);
        p.stimSequ(i,:)=p.flickerSequ;
        p.flickerSequ = repmat([ones(1,p.flickerFrames/2) 2*ones(1,p.flickerFrames/2) 3*ones(1,p.flickerFrames/2) 2*ones(1,p.flickerFrames/2)],1,(0.5)*p.stimExpose/p.flickerFrames);
        p.stimDimSequ(1,:) = zeros(1,size(p.flickerSequ,2));
        % mark the tarket spots with low contrast stims
        for j=1:p.nTargs
            p.stimDimSequ(i,p.targFrame(i,j):p.targFrame(i,j)+2*p.flickerFrames-1) = 1;
            %p.stimSequ(i,p.targFrame(i,j):p.targFrame(i,j)+2*p.flickerFrames-1)=p.stimSequ(i,p.targFrame(i,j):p.targFrame(i,j)+2*p.flickerFrames-1)+2;
            % +2 above --> change to "target"
        end
    end
    
    % use the stim sequences generated above, shuffled wrt trial order, for
    % fix dimming sequences
    p.fixDimSequ = p.stimDimSequ; % 1 if fix dims, 0 if not
    p.rndInd2 = randperm(size(p.fixDimSequ,1));
    p.fixDimSequ = p.fixDimSequ(p.rndInd2,:);
    
    % put up a message to wait for a space bar press
    if p.cond == 1
        textMotion = 'Attend fixation';
        p.validTarget = p.dimFix;
    elseif p.cond == 2
        textMotion = 'Attend checkerboard';
        p.validTarget = p.dimStim;
    elseif p.cond == 3
        textMotion = 'Compare target/probe locations';
        p.validTarget = zeros(size(p.dimFix));
    else
        textMotion = 'Waiting for start of scanner';
        p.validTarget = zeros(size(p.dimFix));
    end 
    
    tCenterMo = [center(1)-RectWidth(Screen('TextBounds', w, textMotion))/2 center(2)/2];
    
    Screen('DrawText', w, textMotion, tCenterMo(1), tCenterMo(2), p.textColor);
    Screen('DrawDots', w, [0,0], p.fixSizePix, p.fixColor, left, 0); %change fixation point
    Screen('DrawingFinished', w);
    Screen('Flip', w);
    
    %after all initialization is done, sit and wait for scanner synch (or
    %space bar)
    resp=0;
%     disp('checking for response');
%     while 1
%         [resp, timeStamp] = checkForResp([p.space,p.start],p.escape);
%         if resp==p.space || resp==p.start || resp==p.escape
%             break;
%         end
%         if resp==-1; ListenChar(0); return; end;
%     end
    
    FlushEvents;
    GetChar;
    
    disp('starting block');
    cumTime = GetSecs;
    
    % start eyetracking...
    if p.eyeTracking
        try
            write_parallel(192); % start recording             
            disp('recording started');
        catch thisError
            disp('Error during recording initiation');
            p.eyeTracking = 0;
            p.eyeTrackingStopped = 'After 192';
            disp(thisError);
        end
    end
    
    waited = 1; % we've already waited for 1 TR here...
    
    p.startExp = cumTime;
    p.TRtimes(waited) = GetSecs;
    disp('waiting...');
    WaitSecs(p.TR/2); % ADDED TCS 4/24/12
    if p.fMRI
        while waited <= p.nTRsWait
            FlushEvents;
            GetChar;
            %while 1
           %     [resp, timeStamp] = checkForResp([p.space,p.start],p.escape);
           %     if resp==p.space || resp==p.start || resp==p.escape
                    waited = waited + 1;
                    p.TRtimes(waited) = GetSecs;
                    disp(sprintf('%i TRs counted',waited));
                    if waited <= p.nTRsWait
                        WaitSecs(p.TR/2);
                    end
                    %break;
            %    end
            %    if resp==-1; ListenChar(0); return; end;
            %end
        end
    end
    
    FlushEvents;
    
    Screen('DrawDots', w, [0,0], p.fixSizePix, p.fixColor, left, 0); %change fixation point
    Screen('DrawingFinished', w);
    Screen('Flip', w);
    cumTime = GetSecs;
    %p.startExp = cumTime;
    
    while GetSecs < cumTime + p.startWait
        [resp, timeStamp] = checkForResp([],p.escape);
        if resp == p.escape
            Screen('CloseAll');
            clear mex;
            return;
        end
        continue;
    end
    
    cumTime = GetSecs;
    
    rTcnt = 1;
    
    save(fName,'p');
    
    %% here is the start of the trial loop
    for t=1:p.nTrials

        xLoc = p.stimLocsX(t);
        yLoc = p.stimLocsY(t);
        
        targXLoc = p.targetLoc(t,1) * cos(p.targetLoc(t,2)) + p.radPix*(xLoc - p.nLoc/2) - p.radPix/2 + p.staggered*p.radPix/4;
        targYLoc = p.targetLoc(t,1) * sin(p.targetLoc(t,2)) + p.radPix*(yLoc - p.nLoc/2) - p.radPix/2 + p.staggered*p.radPix/4;
        probeXLoc = p.probeLoc(t,1) * cos(p.probeLoc(t,2)) + p.radPix*(xLoc - p.nLoc/2)  - p.radPix/2 + p.staggered*p.radPix/4;
        probeYLoc = p.probeLoc(t,1) * sin(p.probeLoc(t,2)) + p.radPix*(yLoc - p.nLoc/2)  - p.radPix/2 + p.staggered*p.radPix/4;
        
        if ~p.fMRI
            disp(sprintf('dim fix = %i, dim stim = %i',p.dimFix(t),p.dimStim(t)));
        end
        
        p.trialStart(t) = GetSecs;
        
        if p.eyeTracking        
            try
                write_parallel(192+t); % event ID will be trial number for now
                disp(sprintf('Start of trial %i',t));
            catch thisError
                disp(thisError);
                p.eyeTracking = 0;
                p.eyeTrackingStopped = sprintf('Start of trial %i (%i)',t,192+t);
            end
        end
        
        stimRect = [center(1) + p.radPix*(xLoc - p.nLoc/2) - p.radPix - p.radPix/2, center(2) + p.radPix*(yLoc - p.nLoc/2) - p.radPix - p.radPix/2 ,...
            center(1) + p.radPix*(xLoc - p.nLoc/2) + p.radPix - p.radPix/2, center(2) + p.radPix*(yLoc - p.nLoc/2) + p.radPix - p.radPix/2];
        stimRect = round(stimRect + p.staggered*p.radPix/4.*[1 1 1 1]); % staggered is -1 for up/left, +1 for down/right
        
        % to draw center of checkerboard...
        %Screen('DrawDots',w,[p.radPix*(xLoc - p.nLoc/2) - p.radPix/2 + p.staggered*p.radPix/4, p.radPix*(yLoc - p.nLoc/2) - p.radPix/2 + p.staggered*p.radPix/4],p.targetSizePix,[0 255 0],left,1);
        
        % TARGET
        Screen('DrawDots',w,[targXLoc targYLoc],p.targetSizePix,p.wmTargetColor,left,1);
        Screen('DrawDots', w, [0,0], p.fixSizePix, p.fixColor, left, 0); 
        Screen('DrawingFinished',w);
        Screen('Flip',w);
        
        while GetSecs <= cumTime + p.wmTargetDur
            [resp, timeStamp] = checkForResp(p.escape, p.escape);
            if resp==-1; ListenChar(0); return; end;
        end
        
        frmCnt=1;
        p.stimStart(t) = GetSecs;   % start a clock to get the stim onset time
        
        % STIMULUS
        while frmCnt<=p.stimExpose % if we want multiple exposure durations, add that here
                       
            % p.cond = 1: fix, p.cond = 2: checkers , 3 = WM task
            
            if ~p.null(t)
                %if p.dimStim(t) && p.stimDimSequ(t,frmCnt) % if stim is dimmed right now, draw a dimStim
                %    Screen('DrawTexture',w,dimStim(p.flickerSequ(1,frmCnt)),Screen('Rect',dimStim(p.flickerSequ(1,frmCnt))),stimRect);
                %else % otherwise, draw a regular stim (both determined by flickerSequ)
                    Screen('DrawTexture',w,stim(p.flickerSequ(1,frmCnt)),Screen('Rect',stim(p.flickerSequ(1,frmCnt))),stimRect);
                %end
                % apperture around fixation
                Screen('DrawDots', w, [0 0], p.appSizePix, p.backColor, left, 1);
                
                %if ~p.dimStim(t) && p.stimSequ(t,frmCnt)>2
                %    Screen('DrawTexture',w, stim(p.stimSequ(t,frmCnt)-2),Screen('Rect',stim(p.stimSequ(t,frmCnt))),stimRect);
                %else
                %    Screen('DrawTexture',w, stim(p.stimSequ(t,frmCnt)),Screen('Rect',stim(p.stimSequ(t,frmCnt))),stimRect);
                %end
                
                %if p.dimFix(t) && p.fixDimSequ(t,frmCnt)
                %    Screen('DrawDots', w, [0,0], p.fixSizePix, p.targetFixColor, left, 0); %change fixation point
                %else
                    Screen('DrawDots', w, [0,0], p.fixSizePix, p.fixColor, left, 0); 
                %end
                Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')
                Screen('Flip', w);
                
                % check response...
                [resp, timeStamp] = checkForResp(p.keys, p.escape); % checks both buttons...
                if GetSecs==-1; ListenChar(0); return; end;
                if resp && find(p.keys==resp)
                    p.resp(t, frmCnt) = find(p.keys==resp);
                end
                % TODO - gather responses longer...

            end
            frmCnt = frmCnt + 1;
        end
        
        p.stimEnd(t) = GetSecs;
                
        % PROBE
        Screen('DrawDots',w,[probeXLoc probeYLoc],p.probeSizePix,p.wmProbeColor,left,1);
        Screen('DrawDots', w, [0,0], p.fixSizePix, p.fixColor, left, 0); 
        Screen('DrawingFinished',w);
        Screen('Flip',w);
        
        while GetSecs <= cumTime + p.stimExposeDur + p.wmTargetDur + p.wmProbeDur
            [resp, timeStamp] = checkForResp(p.keys, p.escape);
            if resp==-1; ListenChar(0); return; end;
            if p.cond == 3
                if resp && find(p.keys==resp)
                    p.wmResp(t) = find(p.keys==resp); % (most recent response is that recorded)
                end
            end
        end
        
        % clear out screen
        Screen('DrawDots', w, [0,0], p.fixSizePix, p.fixColor, left, 0); %draw fixation point
        Screen('Flip',w);
        
        % write end of eyetracking event (give time for return to fix)
        if p.eyeTracking        
            try
                write_parallel(255); % event ID will be trial number for now
                disp(sprintf('ITI of trial %i',t));
                %clear msg out;
            catch thisError
                disp(thisError);
                p.eyeTracking = 0;
                p.eyeTrackingStopped = sprintf('ITI of trial %i (%i)',t,255);
                % attempt to save
            end
        end
        
        while GetSecs <= cumTime + p.trialDur(t)
            [resp, timeStamp] = checkForResp(p.keys, p.escape);
            if resp==-1; ListenChar(0); return; end;
            if p.cond == 3
                if resp && find(p.keys==resp)
                    p.wmResp(t) = find(p.keys==resp); % (most recent response is that recorded)
                end
            end
        end
        
        try
            if p.validTarget(t) && p.cond == 2
                p.targetOnset(t) = find(diff(p.stimDimSequ(t,:))==1);
            elseif p.validTarget(t) && p.cond == 1
                p.targetOnset(t) = find(diff(p.fixDimSequ(t,:))==1);
            end
        end
        
        % compute accuracy (borrowed from MT localizer, SOT3)
        p.actualRespFrm(t).d = find(diff([0,p.resp(t,:)])==1); % since the button may be down for several frames, we want to find the first frame it was recorded as being down
        %if ~isempty(p.actualRespFrm(t).d)
        %    p.respBinary(t) = 1;
        %else
        %    p.respBianry(t) = 0;
        %end
            
        if p.null(t)
            disp(sprintf('Trial %03i: Null',t));
        elseif p.cond == 3 % WM
            mystr = {'no match','match'};
            if p.targetProbeMatch(t) && p.wmResp(t) == 1 || ~p.targetProbeMatch(t) && p.wmResp(t) == 2
                disp(sprintf('Trial %03i: Correct (%s)',t,mystr{p.targetProbeMatch(t)+1}));
                p.wmCorrect = p.wmCorrect + 1;
            else
                disp(sprintf('Trial %03i: Incorrect (%s)',t,mystr{p.targetProbeMatch(t)+1}));
                p.wmIncorrect = p.wmIncorrect + 1;
            end
            clear mystr
        % hits:
        elseif  p.validTarget(t) && ~isempty(p.actualRespFrm(t).d)
            p.hits = p.hits+1;
            p.rt(t) = 0;
            %p.rt(t) = (p.actualRespFrm(t).d(1) - p.targetOnset(t)) * 1/p.fps;
            disp(sprintf('Trial %03i: Hit, with RT = %f',t,p.rt(t)));
        % misses:
        elseif p.validTarget(t) && isempty(p.actualRespFrm(t).d)
            p.misses = p.misses+1;
            %p.rt(t) = -1; p.rt stays as NaN (for nanmean)
            disp(sprintf('Trial %03i: Miss',t));
        % false alarms
        elseif ~p.validTarget(t) && ~isempty(p.actualRespFrm(t).d)
            p.falseAlarms = p.falseAlarms+1;
            p.rt(t) = p.actualRespFrm(t).d(1) * 1/p.fps;
            disp(sprintf('Trial %03i: False Alarm, with RT = %f',t,p.rt(t)));
        % correct rejections
        elseif ~p.validTarget(t) && isempty(p.actualRespFrm(t).d)
            p.correctRejections = p.correctRejections+1;
            p.rt(t) = -1;
            disp(sprintf('Trial %03i: Correct Rejection',t));
        end
        
        cumTime = cumTime + p.trialDur(t);
        rTcnt = rTcnt + 1;  % increment real trial counter.

        p.trialEnd(t) = GetSecs;
        
        save(fName, 'p');
        
    end
    %% end trial loop

    %   10s passive fixation at end of block
    Screen('DrawDots', w, [0,0], p.fixSizePix, p.fixColor, left, 0); %change fixation point
    Screen('DrawingFinished', w);
    Screen('Flip', w);
    while GetSecs <= cumTime + p.passiveDur
        [resp, timeStamp] = checkForResp(p.escape, p.escape);
        if resp==-1; ListenChar(0); return; end;
    end
    
    p.endExp = GetSecs;
    
    p.respBinary = sum(p.resp,2) > 0;
    
    if p.cond == 3
        p.accuracy = p.wmCorrect/(p.wmCorrect+p.wmIncorrect)*100;
    else
        
        p.accuracy = 100*mean(p.respBinary(~p.null)  == p.validTarget(~p.null));
        %p.accuracy = p.hits/sum(p.validTarget)*100;
        p.meanCorrectRT = nanmean(p.rt(find(p.validTarget)));
    end
    
    %save trial data from this block
    save(fName, 'p');
   
    str1 = sprintf('Block %i complete',b);
    tCenter1 = [center(1)-RectWidth(Screen('TextBounds', w, str1))/2 center(2)/2];
    str2 = sprintf('Accuracy: %i%%',round(p.accuracy));
    tCenter2 = [center(1)-RectWidth(Screen('TextBounds', w, str2))/2 center(2)/2];

    Screen('DrawText', w, str1, tCenter1(1), tCenter1(2)-100, p.textColor);
    Screen('DrawText', w, str2, tCenter2(1), tCenter2(2), p.textColor);

    %if p.cond ~= 3
    %    str3 = sprintf('Average response time: %4i ms',round(p.meanCorrectRT*1000));
    %    tCenter3 = [center(1)-RectWidth(Screen('TextBounds', w, str3))/2 center(2)/2];
    %    Screen('DrawText', w, str3, tCenter3(1), tCenter3(2)+100, p.textColor);
    %end
    
    
    % put up a message to wait for a space bar press.
    Screen('Flip', w);
    while resp~=p.space
        [resp, timeStamp] = checkForResp(p.space, p.escape);
        if resp==-1; ListenChar(0); return; end;
    end
    
    % stop recording and save
    if p.eyeTracking
        try
            write_parallel(0); % close file, end recording
        catch thisError
            disp(thisError);
            p.eyeTracking = 0;
            p.eyeTrackingStopped = sprintf('End of block %i',b);
        end
    end
    
end
%% end block loop

ListenChar(0);
Screen('CloseAll');
return


%--------------------------------------------------------------------------
function p = deg2pix(p)
% converts degrees visual angle to pixel units before rendering
% with PTB. Needs p.screenWidthCM and p.vDistCM
% js - 10.2007

% figure out pixels per degree, p.sRect(1) is x coord for upper left of
% screen, and p.sRect(3) is x coord for lower right corner of screen
p.ppd = pi * (p.sRect(3)-p.sRect(1)) / atan(p.screenWidthCM/p.vDistCM/2) / 360;

% get name of each field in p
s = fieldnames(p);

% convert all fields with the word 'Deg' from degrees visual angle to
% pixels, then store in a renmaed field name
for i=1:length(s)
    ind = strfind(s{i}, 'Deg');
    if ind
        curVal = getfield(p,s{i});
        tmp = char(s{i});
        newfn = [tmp(1:ind-1), 'Pix'];
        p = setfield(p,newfn,curVal*p.ppd);
    end
end
