function [p, points, block_points] = FNLine_Loop(filename, LR, win, color, p, points, TestNLine, block_points)
%Controls the loop that executes fraction number line task
%returns p struct with all the results and stim logged and updated points
%for measure of accuracy

try
    task = 'keyb';
    
    DisplayInstructs3;
    
    %practice trials
    p_points = 0;
    block_p_points = 0;
    fix = 'X';
    prac1 = [1 2 1 6 10];
    prac2 = [1 3 0 -1 -1];
    prac3 = [16 24 1 13 20];
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac1, win, color, task, p.consider);
    block_p_points = FractLineRGSlow(prac1, win, 600, 1, color, p.decision, block_p_points); %Large example
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac2, win, color, task, p.consider); %No answer example
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac3, win, color, task, p.consider);
    block_p_points = FractLineRGSlow(prac3, win, 600, 1, color, p.decision, block_p_points); % Small example
    p_points = block_p_points;
    DisplayInstructsPractice;
    block_p_points = 0;
    prac4 = [1 7 1 3 30];
    prac5 = [2 6 1 1 4];
    prac6 = [11 21 1 3 5];
    prac7 = [6 8 0 -1 -1];
    prac8 = [10 26 1 2 8];
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    ConsiderSlow(prac4, win, color, task, p.consider);%consider
    block_p_points = FractLineRGSlow(prac4, win, 600, 1, color, p.decision, block_p_points); %decision
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    ConsiderSlow(prac5, win, color, task, p.consider);%consider
    block_p_points = FractLineRGSlow(prac5, win, 600, 1, color, p.decision, block_p_points); %decision
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    ConsiderSlow(prac6, win, color, task, p.consider);%consider
    block_p_points = FractLineRGSlow(prac6, win, 600, 1, color, p.decision, block_p_points); %decision
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    ConsiderSlow(prac7, win, color, task, p.consider);%consider
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    ConsiderSlow(prac8, win, color, task, p.consider);%consider
    block_p_points = FractLineRGSlow(prac8, win, 600, 1, color, p.decision, block_p_points); %decision
    p_points = block_p_points + p_points;
    DisplayInstructs4; %End of practice ask question and get ready to start
    
    
    
    
    blockNbr_NLine = 0;
    
    % The idea is the kk will signal
    % which portion of the #D matrix TestNLine will be used for the
    % rest of the code and in principle the rest should not be changed
    start_t0 = GetSecs;
    p.start_NLine=datestr(now); % for record purpose
    
    for kk = 1:p.runs;
    
        block_points = points;
        % wait for scanner trigger '5'
        DrawCenteredNum('Waiting for experimenter', win, color, 0.3);
        WaitTill('9');
        DrawCenteredNum('Waiting for scanner', win, color, 0.3);
        WaitTill('5'); %Use this only if used in a scanner that sends 5
        start_t = GetSecs;
    
        for ii = 1:(p.nRepeats/p.runs);
            blockNbr_NLine = blockNbr_NLine+1;
            for jj = 1:p.nStim;
                trialNbr_NLine = (p.nStim * (blockNbr_NLine-1)) + jj; % This counts across blocks
                trialNbr = (p.nStim * (ii-1)) + jj; %This counts within block
                end_fix = p.numlineResults{trialNbr+1,15,kk} + start_t;
                end_cons = p.numlineResults{trialNbr+1,16,kk} + start_t;
                end_decision = p.numlineResults{trialNbr+1,17,kk} + start_t;
                DrawCenteredNum_Abs('X', win, color);
                p.numlineResults(trialNbr+1,19,kk) = {GetSecs - start_t}; %Real onset of fixation
                WaitTill(end_fix);
                p.numlineResults(trialNbr+1,20,kk) = {GetSecs - start_t}; %Real onset of consider
                p.numlineResults(trialNbr+1,1:3,kk) = ConsiderSlow_Abs(TestNLine(trialNbr,:,kk), win, color, task, end_cons);
                WaitTill(end_cons);
                p.numlineResults(trialNbr+1,21,kk) = {GetSecs - start_t}; %Real onset of decision
                p.numlineResults(trialNbr+1,4:11,kk) = FractLineRGSlow_Abs(TestNLine(trialNbr,:,kk), win, 600, 1, color, end_decision, p.numlineResults{trialNbr+1,18,kk}, points, LR);
                WaitTill(end_decision);
                p.numlineResults(trialNbr+1,12,kk) = {trialNbr_NLine};
                p.numlineResults(trialNbr+1,13,kk) = {blockNbr_NLine};
                points = p.numlineResults{trialNbr+1,11,kk};
            end
        end
        end_t = GetSecs - start_t;
        p.time_Runs(kk+1,3) = {end_t};
        block_points = points - block_points;
        DrawCenteredNum(fix, win, color, 3);%fixation to pad end of scan
        DisplayInstructs2;
    end
    end_t = GetSecs - start_t0;
    p.finish_NLine = datestr(now);
    
catch
    sca
    ple
    ShowCursor
    save([filename '_catch4']);
    save(filename, 'p');
    ListenChar(1);
end