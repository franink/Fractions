% Code for fMRI experiment of fractions using absolute time instead of
% relative time for more precision.
% Modified from Cameron McKenzie's code
% Tanks to Xiangrui Li for the codes for WaitTill and ReadKey.

%make sure no Java problems
PsychJavaTrouble;

%Parameter to scale size on monitor... pixel per cm adjustment
ppc_adjust = 38/23; % Need to ask what these numbers mean exactly and why these and not others.

% In case previous subject was not cleared
clear Instruct;

%Filename to save data
filename = getFracFilename();

%Cursor helps no one here - kill it
HideCursor;


%Don't show characters on matlab screen
ListenChar(2);

%load up stimuli
load FracStim;

%Setup experiment parameters
p.practice_time = 1; % Need to figure out how much practice I need
p.fixation = 6;
p.consider = 2;
p.decision = 3;
p.pct_catch = 0.3; % proportion of trials that have a test (decision) phase
%Make sure that repeats is divisible by runs
p.runs = 2; %within a single task
p.tasks = 2;
p.nRepeats = 6; %repeats per run This is probably going to be larger than 4 
p.nStim = 4;
p.tasks = {'NumMatch', 'NumLine'};
p.trialSecs = p.fixation + p.consider + (p.decision*p.pct_catch);


%Randomize stims for three parts of experiment
%Don't allow two consecutive equal fractions
rng shuffle;

%assign randomly catch trials to each stim
ctch_nbr = round(p.nRepeats*p.pct_catch);
ctch = [ones(ctch_nbr,1); zeros(p.nRepeats - ctch_nbr,1)];
%ctch_temp = ctch(tmp(randperm(p.nRepeats)));
TestNumMatch = zeros(p.nRepeats*p.nStim,3);
TestFracsLine = zeros(p.nRepeats*p.nStim,3);

for ii = 1:p.nStim;
    ctch_temp = ctch(randperm(p.nRepeats));
    for jj = 1:p.nRepeats
        TestNumMatch(ii+((jj - 1)*p.nStim), 1:2) = FracStim(ii,:);
        TestNumMatch(ii+((jj - 1)*p.nStim), 3) = ctch_temp(jj);
    end
end

for ii = 1:p.nStim;
    ctch_temp = ctch(randperm(p.nRepeats));
    for jj = 1:p.nRepeats
        TestFracsLine(ii+((jj - 1)*p.nStim), 1:2) = FracStim(ii,:);
        TestFracsLine(ii+((jj - 1)*p.nStim), 3) = ctch_temp(jj);
    end
end
    

%Shuffle trials within block
for ii = 1:p.nRepeats
    TestNumMatch(((ii-1)*p.nStim)+1:((ii-1)*p.nStim)+p.nStim,:) = TestNumMatch(randperm(p.nStim)+(p.nStim*(ii-1)),:);
end

for ii = 1:p.nRepeats
    TestFracsLine(((ii-1)*p.nStim)+1:((ii-1)*p.nStim)+p.nStim,:) = TestFracsLine(randperm(p.nStim)+(p.nStim*(ii-1)),:);
end

%Results files
p.nMatchResults = cell(length(TestNumMatch)+1,20);
p.numlineResults = cell(length(TestFracsLine)+1,20);
p.time_Runs = cell(1+p.runs,p.tasks);


%Get Labels
p.nMatchResults(1,:) = {'Num','Denom','Value','Cons_RT','Mouse_Pos','Correct','Response','RT','Error','Points','Trial','Block','fix_onset','cons_onset','decision_onset','decision_end','catch','fix_onset_real','cons_onset_real','decision_onset_real'};    
%fCompResults(1,:) = {'Num','Denom','Value','Cons_RT','Target','Correct','Response','RT','Acc'};
p.numlineResults(1,:) = {'Num','Denom','Value','Cons_RT','Mouse_Pos','Correct','Response','RT','Error','Points','Trial','Block','fix_onset','cons_onset','decision_onset','decision_end','catch','fix_onset_real','cons_onset_real','decision_onset_real'};
p.time_Runs(1,:) ={'Time_Match', 'Time_NumLine'}; %this might change if number of runs changes

%Add catch information
for ii = 2:length(p.nMatchResults);
    p.nMatchResults(ii,17) = {TestNumMatch(ii-1,3)};
    p.numlineResults(ii,17) = {TestFracsLine(ii-1,3)};
end

% Separate runs into different 3D matrices
Testcomponents = zeros(p.nStim*(p.nRepeats/p.runs),3,p.runs);
Testfractions = zeros(p.nStim*(p.nRepeats/p.runs),3,p.runs);
for ii = 1:p.runs
    Testcomponents(:,:,ii) = TestNumMatch(1+((ii-1)*p.nStim):p.nStim+((ii-1)*p.nStim),:);
    Testfractions(:,:,ii) = TestFracsLine(1+((ii-1)*p.nStim):p.nStim+((ii-1)*p.nStim),:);
end


% Open a PTB Window on our screen
try
    screenid = min(Screen('Screens')); %Originally it was max instead of min changed it for testing purposes (max corresponds to secondary display)
    
    [win, winRect] = Screen('OpenWindow', screenid, WhiteIndex(screenid)/2);
    
    color = [255 255 255 255]; %Cam's value was 0 200 255
catch
end

% Setup the onsets for each stimulus
% simulates going through the whole run and kees track of time and catch
% events
end_practice = p.practice_time;
current_time = end_practice; %keeps track of time, starts with time after practice
for ii = 1:length(p.nMatchResults)-1;
    p.nMatchResults(ii+1,13) = {current_time}; %fixation onset
    current_time = current_time + p.fixation; %end of fixation
    p.nMatchResults(ii+1,14) = {current_time}; %consider onset
    current_time = current_time + p.consider; %end of consider
    p.nMatchResults(ii+1,15) = {current_time}; %decision onset
    current_time = current_time + (p.decision * ctch1(ii)); %end of decision if ctch 1 = 0 current time does not move
    p.nMatchResults(ii+1,16) = {current_time}; %end of decision
end

% and now for numberline
end_practice = p.practice_time;
current_time = end_practice; %keeps track of time, starts with time after practice
for ii = 1:length(p.numlineResults)-1;
    p.numlineResults(ii+1,13) = {current_time}; %fixation onset
    current_time = current_time + p.fixation; %end of fixation
    p.numlineResults(ii+1,14) = {current_time}; %consider onset
    current_time = current_time + p.consider; %end of consider
    p.numlineResults(ii+1,15) = {current_time}; %decision onset
    current_time = current_time + (p.decision * ctch2(ii)); %end of decision if ctch 1 = 0 current time does not move
    p.numlineResults(ii+1,16) = {current_time}; %end of decision
end


% Stage 1 - Component NL

try
       
    task = 'mouse';
    
    %DisplayInstructsNComp;
    DisplayInstructs1; %Need to change instructions
    
    
    points = 0; %This initializes points for accuracy calculation
    
    % Need to implement this correctly. The idea is the kk will signal
    % which portion of the #D matrix testcomponent will be used for the
    % rest of the code and in principle the rest should not be changed
    % (except for names0
    for kk = 1:p.runs;
        
        % wait for scanner trigger '5'
        %startSecs=WaitTrigger; %Use this only if used in a scanner that sends 5
        % Don't have the function WaitTrigger probably works with WaitTill('5')
        start_t = GetSecs;
        p.start_match_kk=datestr(now); % for record purpose
    
        %This needs to be fixed but is the beginning of the fixation code
        %Here probably there will be something about practice and fixation time
%       fixation = ['X', 'X'];
%       DrawCenteredFrac(fixation,win,color);
%       Screen('Flip', win);
        for ii = 1:(p.nRepeats/p.runs);
            for jj = 1:p.nStim;
                blockNbr_Match = ii;
                trialNbr_Match = (p.nStim * (blockNbr_Match-1)) + jj;
                end_fix = p.nMatchResults{trialNbr_Match+1, 14} + start_t;
                end_cons = p.nMatchResults{trialNbr_Match+1, 15} + start_t;
                end_decision = p.nMatchResults{trialNbr_Match+1, 16} + start_t;
                DrawCenteredNum_Abs('X', win, color);
                p.nMatchResults(trialNbr_Match+1, 18) = {GetSecs - start_t}; %Real onset of fixation
                WaitTill(end_fix);
                %%% I need to pass end_time to the functions so that they can
                %%% use it to figure when to exit from the script
                p.nMatchResults(trialNbr_Match+1, 19) = {GetSecs - start_t}; %Real onset of consider
                p.nMatchResults(trialNbr_Match+1,1:4) = ConsiderSlow_Abs(TestNumMatch(trialNbr_Match,:), win, color, task,end_cons);
                %Screen('Flip',win);
                WaitTill(end_cons);
                p.nMatchResults(trialNbr_Match+1, 20) = {GetSecs - start_t}; %Real onset of deciison
                p.nMatchResults(trialNbr_Match+1,5:10) = NumLineRGSlow_Abs(TestNumMatch(trialNbr_Match,:), win, 600, 1, color,end_decision, p.nMatchResults{trialNbr_Match+1,17}, points);
                WaitTill(end_decision);
                p.nMatchResults(trialNbr_Match+1,11) = {trialNbr_Match};
                p.nMatchResults(trialNbr_Match+1,12) = {blockNbr_Match};
                points = p.nMatchResults(trialNbr_Match+1,10);
            end
        end
    end
    
    end_t = GetSecs - start_t;
    p.finish_match_kk = datestr(now);
    p.time_Runs(2,1) = {end_t};
catch
    ple
    ShowCursor
    sca
    save([filename '_catch2']);

end

% Stage 2 Fraction numberline task:

try
    task = 'mouse';
    
    %A neat little script that displays instructions for section two
    %DisplayInstructs;
    DisplayInstructs3;
    
    % wait for scanner trigger '5'
    %startSecs=WaitTrigger; %Use this only if used in a scanner that sends 5
    start_t = GetSecs;
    p.start_NLine=datestr(now); % for record purpose
    
%This needs to be fixed but is the beginning of the fixation code
    %Here probably there will be something about practice and fixation time
%     fixation = ['X', 'X'];
%     DrawCenteredFrac(fixation,win,color);
%     Screen('Flip', win);


    for ii = 1:p.nRepeats;
            for jj = 1:p.nStim;
                blockNbr_NLine = ii;
                trialNbr_NLine = (p.nStim * (blockNbr_NLine-1)) + jj;
                end_fix = p.numlineResults{trialNbr_NLine+1, 14} + start_t;
                end_cons = p.numlineResults{trialNbr_NLine+1, 15} + start_t;
                end_decision = p.numlineResults{trialNbr_NLine+1, 16} + start_t;
                DrawCenteredNum_Abs('X', win, color);
                p.numlineResults(trialNbr_NLine+1, 18) = {GetSecs - start_t}; %Real onset of fixation
                WaitTill(end_fix);
                p.numlineResults(trialNbr_NLine+1, 19) = {GetSecs - start_t}; %Real onset of consider
                p.numlineResults(trialNbr_NLine+1,1:4) = ConsiderSlow_Abs(TestFracsLine(trialNbr_NLine,:), win, color, task, end_cons);
                WaitTill(end_cons);
                p.numlineResults(trialNbr_NLine+1, 20) = {GetSecs - start_t}; %Real onset of decision
                p.numlineResults(trialNbr_NLine+1, 5:10) = FractLineRGSlow_Abs(TestFracsLine(trialNbr_NLine,:), win, 600, 1, color, end_decision, p.numlineResults{trialNbr_NLine+1,17}, points);
                WaitTill(end_decision);
                p.numlineResults(trialNbr_NLine+1,11) = {trialNbr_NLine};
                p.numlineResults(trialNbr_NLine+1,12) = {blockNbr_NLine};
                points = p.numlineResults(trialNbr_NLine+1,10);
            end
    end

    end_t = GetSecs - start_t;
    p.finish_NLine = datestr(now);
    p.time_Runs(2,2) = {end_t};
    DrawCenteredNum('Thank You', win, color, 2);
    
    
    
catch
    sca
    ple
    ShowCursor
    save([filename '_catch3']);
    Screen('Flip', win);

end

%save results
save(filename, 'p')
ListenChar(0);
ShowCursor;
%Show characters on matlab screen again
sca;
close all;