%This script is copyright Cameron McKenzie. All reasonable requests for use
%will be granted, but please do not use or alter without permission or
%attribution. Thanks to Brett Foster and the Parvizi lab for code snippets
%and support to incorporate timestamps for ECOG data collection and achieve
%correct display parameters on Parvizi lab setup.

%Script author can be contacted: crlmck@stanford.edu || cmckenz@gmail.com

%This script runs three experiments on numerical cognition.

%The final version will include timestamping pulses to time sync to ECOG
%data collection.

%Experiment one is a replication of Moyer and Landauer's (1967) classic
%distance effect task: magnitude comparison of every pair of natural
%numbers between 1 and 9. Vars: RT, response.

%Experiment two extends this task to fraction magnitude comparison, against
%a remembered standard of 3/5, using fractions in (0, 1) with single
%digit numerator and denominator. This task follows Schneider and Siegler
%(2010) as well as McKenzie and McClelland (in prep). Vars: RT, response.

%Experiment three requires the subject to mark each fraction from
%experiment two on a numberline that spans the interval [0, 1]. This task
%follows McKenzie and McClelland (in prep) Vars: %Reading time on first
%screen, RT on screen 2, numberline mark position.

%Leeeeets geeeeet readdddy to rrruruuuuuuummmmmmbbbbbllllleeeeeee...

%make sure no Java problems
PsychJavaTrouble;

%Parameter to scale size on monitor... pixel per cm adjustment
ppc_adjust = 38/23; % Need to ask what these numbers mean exactly and why these and not others.

%Filename to save data
filename = getFracFilename()

%Cursor helps no one here - kill it
HideCursor;


%Don't show characters on matlab screen
ListenChar(2)

%load up stimuli
load ECOG_Stims

%Randomize stims for three parts of experiment
%Don't allow two consecutive equal fractions
rng shuffle;

%for j = 1:8
%   FracStim(((2*18)-17:2*18),:)

a = 1:18;
b = 19:36;
c = 37:54;
d = 55:72;
e = 73:90;
f = 91:108;
g = 109:126;
h = 127:144;

%TestNatComp = [NatStim(randperm(length(NatStim)), :); NatStim(randperm(length(NatStim)), :)];
TestNumMatch = [FracStim(a(randperm(18)), :);
                FracStim(b(randperm(18)), :);
                FracStim(c(randperm(18)), :);
                FracStim(d(randperm(18)), :);
                FracStim(e(randperm(18)), :);
                FracStim(f(randperm(18)), :);
                FracStim(g(randperm(18)), :);
                FracStim(h(randperm(18)), :)];

TestFracsComp = [FracStim(a(randperm(18)), :);
                FracStim(b(randperm(18)), :);
                FracStim(c(randperm(18)), :);
                FracStim(d(randperm(18)), :);
                FracStim(e(randperm(18)), :);
                FracStim(f(randperm(18)), :);
                FracStim(g(randperm(18)), :);
                FracStim(h(randperm(18)), :)];

TestFracsLine = [FracStim(a(randperm(18)), :);
                FracStim(b(randperm(18)), :);
                FracStim(c(randperm(18)), :);
                FracStim(d(randperm(18)), :);
                FracStim(e(randperm(18)), :);
                FracStim(f(randperm(18)), :);
                FracStim(g(randperm(18)), :);
                FracStim(h(randperm(18)), :)];       
            
            
%     TestFracsComp = [FracStim(randperm(length(FracStim)),:); FracStim(randperm(length(FracStim)),:)];
%     TestFracsLine = [FracStim(randperm(length(FracStim)),:); FracStim(randperm(length(FracStim)),:)];


% Setup result files
nMatchResults = cell(length(TestNumMatch)+1,9);
%nMatchResults = zeros(length(TestNumMatch + 1),9);    
%fCompResults = zeros(length(TestFracsComp + 1), 9);
%numlineResults = zeros(length(TestFracsLine + 1),9); %still need to setup this completely
fCompResults = cell(length(TestFracsComp)+1, 9);
numlineResults = cell(length(TestFracsLine)+1,9); %still need to setup this completely

%Get Labels (need to work on this probably change data type
nMatchResults(1,:) = {'Num','Denom','Value','Cons_RT','Match','Correct','Response','RT','Acc'};    
fCompResults(1,:) = {'Num','Denom','Value','Cons_RT','Target','Correct','Response','RT','Acc'};
numlineResults(1,:) = {'Num','Denom','Value','Cons_RT','Mouse_Pos','Correct','Response','RT','Error'};


% Open a PTB Window on our screen
try
    screenid = min(Screen('Screens')); %Originally it was max instead of min changed it for testing purposes (max corresponds to secondary display)
    
    [win winRect] = Screen('OpenWindow', screenid, WhiteIndex(screenid)/2);
    
    color = [255 255 255 255]; %Cam's value was 0 200 255
catch
end



% Stage 1 - natural number comparison (Now NumMatch)
try
    
    %DisplayInstructsNComp;
    DisplayInstructs1;
   
    
    task = 'keyb';
    for ii = 1:3 %length(TestNumMatch) %right now is 5 just to test quickly
    	nMatchResults(ii+1,1:4) = Consider(TestNumMatch(ii,:), win, color, task);
        Screen('Flip',win);
        nMatchResults(ii+1,5:9) = NumMatch(TestNumMatch(ii,:), win, color);
    end

catch
    ple
    ShowCursor
    sca
    save([filename '_catch2']);

end



% Stage 2 - fraction comparison
try
 
    %RefFract = [3 5];
    
    %DisplayInstructsFComp;
    DisplayInstructs2;
   
    
    task = 'keyb';    
    for ii = 1:3 %length(TestFracsComp) %right now is 5 just to test quickly
    	fCompResults(ii+1,1:4) = Consider(TestFracsComp(ii,:), win, color, task);
        Screen('Flip',win);
        fCompResults(ii+1,5:9) = fractCompSingle(TestFracsComp(ii,1:2), win, color);
    end

catch
    ple
    ShowCursor
    sca
    save([filename '_catch2']);

end
        
        




%Fraction numberline task:

try
    task = 'mouse';
    %A neat little script that displays instructions for section two
    %DisplayInstructs;
    DisplayInstructs3;

    for ii = 1:3 %length(TestFracsLine) %ßright now is 5 just to test quickly
        numlineResults(ii+1,1:4) = Consider(TestFracsLine(ii,:), win, color, task);
        Screen('Flip',win);
        numlineResults(ii+1,5:9) = FractLineRG(TestFracsLine(ii,:), win, 600, 1, color); %think about length of line
    end
    
catch
    sca
    ple
    ShowCursor
    save([filename '_catch3']);

end

%save results
save(filename, 'nMatchResults', 'fCompResults', 'numlineResults')
ShowCursor;
%Show characters on matlab screen again
ListenChar(0)
sca;
close all;
clear all;





