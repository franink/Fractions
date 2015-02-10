% Code for fMRI experiment of fractions using absolute time instead of
% relative time for more precision.
% Modified from Cameron McKenzie's code
% Tanks to Xiangrui Li for the codes for WaitTill and ReadKey.

%make sure no Java problems
PsychJavaTrouble;
rng shuffle;

%Parameter to scale size on monitor... pixel per cm adjustment
ppc_adjust = 38/23; % Need to ask what these numbers mean exactly and why these and not others.

% In case previous subject was not cleared
clear Instruct;

%Filename to save data
filename = getNlineFilename();

%Use number in filename to counter balance
s_nbr = str2num(filename(7:11));

% counter balance hand
% odds left= yes/larger
% evens right = yes/larger
% odds = 1; evens = 0
%Commented out because we are changing to a different response box
% LR = mod(s_nbr,2);
% if LR == 0;
%     p.LeftHand = 'Smaller';
% end;
% if LR == 1;
%     p.LeftHand = 'Larger';
% end;
LR = 0;

% counter balance task order
% order [0] = match 1st; fraction comparison 2nd
% order [1] = fraction comparison 1; match 2nd
% order [0] = match 1st; fraction comparison 2nd
order = mod(s_nbr,6);

if order == 0;
    p.order = {'nline', 'fline', 'control'};
end

if order == 1;
    p.order = {'nline', 'control', 'fline'};
end

if order == 2;
    p.order = {'fline', 'nline', 'control'};
end

if order == 3;
    p.order = {'fline', 'control', 'nline'};
end

if order == 4;
    p.order = {'control', 'nline', 'fline'};
end

if order == 5;
    p.order = {'control', 'fline', 'nline'};
end

%Cursor helps no one here - kill it
HideCursor;


%Don't show characters on matlab screen
ListenChar(2);

%load up stimuli
load NlineStim;
load WordStim;

%Setup experiment parameters
p.ramp_up = 8; %This number needs to be changed once we know TR (this should be TR*4)
p.fixation = 3;
p.decision = 3;
%Make sure that repeats is divisible by runs
p.runs = 2; %within a single task
p.nRepeats = 10; %repeats across runs. Divisible by p.runs 
p.nStim = 20;
p.tasks = {'Nline', 'Fline', 'Control'}; 
p.trialSecs = p.fixation + p.decision;


%to insure they all have the same time length
TestNline = zeros(p.nRepeats*p.nStim,2); %probe, line_pct
TestFline = zeros(p.nRepeats*p.nStim,4); %probe, line_pct, num, denom 
%TestControl = zeros(p.nRepeats*p.nStim,2); %probe, line_pct
TestControl = cell(p.nRepeats*p.nStim,2); %probe, line_pct


% First Nline task
for ii = 1:p.nStim;
    for kk = 1:p.runs;
        for jj = 1:p.nRepeats/p.runs;
            TestNline(ii+((kk-1)*(p.nStim*(p.nRepeats/p.runs))+((jj-1)*(p.nStim))), 1:2) = [NlineStim(ii,1) NlineStim(ii,1)/100];
        end
    end
end

% Now for Fline task
for ii = 1:p.nStim;
    for kk = 1:p.runs;
        for jj = 1:p.nRepeats/p.runs;
            TestFline(ii+((kk-1)*(p.nStim*(p.nRepeats/p.runs))+((jj-1)*(p.nStim))), 1:4) = [NlineStim(ii,2)/NlineStim(ii,3) NlineStim(ii,2)/NlineStim(ii,3) NlineStim(ii,2) NlineStim(ii,3)];
        end
    end
end

%Now for Control task (Do we want the same word paired always with the same
%position?
for ii = 1:p.nStim;
    for kk = 1:p.runs;
        for jj = 1:p.nRepeats/p.runs;
            tmp = {WordStim{ii,1} NlineStim(ii,1)/100};
            TestControl(ii+((kk-1)*(p.nStim*(p.nRepeats/p.runs))+((jj-1)*(p.nStim))), 1:2) = [tmp(1) tmp{2}]; %Note this is a cell and has to be changed in loop and ControlSlow_Abs
        end
    end
end


%Shuffle trials within block

%First for Nline
%For each repetition(indexed at nStim intervals), scramble the order within
%that interval
for ii = 1:p.nRepeats
    TestNline(((ii-1)*p.nStim)+1:((ii-1)*p.nStim)+p.nStim,:) = TestNline(randperm(p.nStim)+p.nStim*(ii-1),:);
end
% Now for Fline
for ii = 1:p.nRepeats
    TestFline(((ii-1)*p.nStim)+1:((ii-1)*p.nStim)+p.nStim,:) = TestFline(randperm(p.nStim)+p.nStim*(ii-1),:);
end
% Now for Control
for ii = 1:p.nRepeats
    TestControl(((ii-1)*p.nStim)+1:((ii-1)*p.nStim)+p.nStim,:) = TestControl(randperm(p.nStim)+p.nStim*(ii-1),:);
end

% Create Results files
p.NlineResults = cell(p.nStim*(p.nRepeats/p.runs)+1,15,p.runs);
p.FlineResults = cell(p.nStim*(p.nRepeats/p.runs)+1,18,p.runs);
p.ControlResults = cell(p.nStim*(p.nRepeats/p.runs)+1,15,p.runs);
p.time_Runs = cell((p.runs+1),length(p.tasks));

%Get Labels
for ii = 1:p.runs
    p.NlineResults(1,:,ii) = {'Probe', 'Line_pct','Correct','Response','RT','Error','Points', 'mouse_pos','Trial','Block','fix_onset','decision_onset','decision_end','fix_onset_real','decision_onset_real'};    
    p.FlineResults(1,:,ii) = {'Probe', 'Line_pct', 'Num','Denom','Value','Correct','Response','RT', 'Error', 'Points', 'mouse_pos','Trial','Block','fix_onset','decision_onset','decision_end','fix_onset_real','decision_onset_real'};
    p.ControlResults(1,:,ii) = {'Probe', 'Line_pct','Correct','Response','RT','Error','Points','mouse_pos', 'Trial','Block','fix_onset','decision_onset','decision_end','fix_onset_real','decision_onset_real'};
    
end

p.time_Runs(1,:) ={'Time_Nline', 'Time_Fline', 'Time_Control'}; 

% Separate runs into different 3D matrices to control time indpeendently
% for each run
NlineTime = zeros(p.nStim*(p.nRepeats/p.runs),2,p.runs);
FlineTime = zeros(p.nStim*(p.nRepeats/p.runs),4,p.runs);
%ControlTime = zeros(p.nStim*(p.nRepeats/p.runs),2,p.runs);
ControlTime = cell(p.nStim*(p.nRepeats/p.runs),2,p.runs);

for ii = 1:p.runs
    NlineTime(:,:,ii) = TestNline(1+((ii-1)*p.nStim*(p.nRepeats/p.runs)):(p.nStim*(p.nRepeats/p.runs))+((ii-1)*(p.nStim*(p.nRepeats/p.runs))),:);
    FlineTime(:,:,ii) = TestFline(1+((ii-1)*p.nStim*(p.nRepeats/p.runs)):(p.nStim*(p.nRepeats/p.runs))+((ii-1)*(p.nStim*(p.nRepeats/p.runs))),:);
    ControlTime(:,:,ii) = TestControl(1+((ii-1)*p.nStim*(p.nRepeats/p.runs)):(p.nStim*(p.nRepeats/p.runs))+((ii-1)*(p.nStim*(p.nRepeats/p.runs))),:);
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

% First for Nline
for jj = 1:p.runs
    end_ramp_up = p.ramp_up; % after ramp_up the first fixation begins
    current_time = end_ramp_up; %keeps track of time, starts with time after ramp_up
    for ii = 1:length(p.NlineResults(:,1,1))-1;
        p.NlineResults(ii+1,11,jj) = {current_time}; %fixation onset
        current_time = current_time + p.fixation; %end of fixation
        p.NlineResults(ii+1,12,jj) = {current_time}; %decision onset
        current_time = current_time + p.decision; %end of decision
        p.NlineResults(ii+1,13,jj) = {current_time}; %end of decision
    end
end

%Fline
for jj = 1:p.runs
    end_ramp_up = p.ramp_up; %practice time might include ramp_up
    current_time = end_ramp_up; %keeps track of time, starts with time after practice
    for ii = 1:length(p.FlineResults(:,1,1))-1;
        p.FlineResults(ii+1,14,jj) = {current_time}; %fixation onset
        current_time = current_time + p.fixation; %end of fixation
        p.FlineResults(ii+1,15,jj) = {current_time}; %decision onset
        current_time = current_time + p.decision; %end of decision
        p.FlineResults(ii+1,16,jj) = {current_time}; %end of decision
    end
end


% and now for Control
for jj = 1:p.runs
    end_ramp_up = p.ramp_up; %practice time might include ramp_up
    current_time = end_ramp_up; %keeps track of time, starts with time after practice
    for ii = 1:length(p.ControlResults(:,1,1))-1;
        p.ControlResults(ii+1,11,jj) = {current_time}; %fixation onset
        current_time = current_time + p.fixation; %end of fixation
        p.ControlResults(ii+1,12,jj) = {current_time}; %decision onset
        current_time = current_time + p.decision; %end of decision
        p.ControlResults(ii+1,13,jj) = {current_time}; %end of decision
    end
end

% Start of experiment
points = 0; %This initializes points for accuracy calculation
block_points = 0;
%Introductory instructions
DrawCenteredNum('Welcome', win, color, 0.5);
WaitTill('9');
DisplayInstructsInt;

%COunterbalance task order
if order == 0;
    p.order = {'nline', 'fline', 'control'};
    [p, points, block_points] = Nline_Loop(filename, win, color, p, points, NlineTime, block_points);
    %[p, points, block_points] = Fline_Loop(filename, win, color, p, points, FlineTime, block_points);
    %[p, points, block_points] = Control_Loop(filename, win, color, p, points, ControlTime, block_points);
end

if order == 1;
    p.order = {'nline', 'control', 'fline'};
    [p, points, block_points] = Nline_Loop(filename, win, color, p, points, NlineTime, block_points);
    %[p, points, block_points] = Control_Loop(filename, win, color, p, points, ControlTime, block_points);
    %[p, points, block_points] = Fline_Loop(filename, win, color, p, points, FlineTime, block_points);
end

if order == 2;
    p.order = {'fline', 'nline', 'control'};
    %[p, points, block_points] = Fline_Loop(filename, win, color, p, points, FlineTime, block_points);
    [p, points, block_points] = Nline_Loop(filename, win, color, p, points, NlineTime, block_points);
    %[p, points, block_points] = Control_Loop(filename, win, color, p, points, ControlTime, block_points);
end

if order == 3;
    p.order = {'fline', 'control', 'nline'};
    %[p, points, block_points] = Fline_Loop(filename, win, color, p, points, FlineTime, block_points);
    %[p, points, block_points] = Control_Loop(filename, win, color, p, points, ControlTime, block_points);
    [p, points, block_points] = Nline_Loop(filename, win, color, p, points, NlineTime, block_points);
end

if order == 4;
    p.order = {'control', 'nline', 'fline'};
    %[p, points, block_points] = Control_Loop(filename, win, color, p, points, ControlTime, block_points);
    [p, points, block_points] = Nline_Loop(filename, win, color, p, points, NlineTime, block_points);
    %[p, points, block_points] = Fline_Loop(filename, win, color, p, points, FlineTime, block_points);
end

if order == 5;
    p.order = {'control', 'fline', 'nline'};
    %[p, points, block_points] = Control_Loop(filename, win, color, p, points, ControlTime, block_points);
    %[p, points, block_points] = Fline_Loop(filename, win, color, p, points, FlineTime, block_points);
    [p, points, block_points] = Nline_Loop(filename, win, color, p, points, NlineTime, block_points);
end


%DrawCenteredNum('Thank You', win, color, 2);
    
%save results
save(filename, 'p')
ListenChar(1)
ShowCursor;
%Show characters on matlab screen again
close all;
sca