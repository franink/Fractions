function [p, points, block_points] = Nline_Loop(filename, win, color, p, points, NlineTest, block_points)
%Controls the loop that executes fraction summation task
%returns p struct with all the results and stim logged and updated points
%for measure of accuracy

% Nline task

try
    
    winRect = Screen('Rect', win);
    yline = round(winRect(4)/2);
    center = winRect(3)/2;
    
    ppc_adjust = 23/38;
  
    lineLength = round(900*ppc_adjust);
    lineSZ = round(20*ppc_adjust);
    
    rng shuffle;
    jitter = 0;
    jitter = jitter*randi([-300 300]);
    jitter = round(jitter*ppc_adjust);% Here position of line is jittered
    
    x1 = round(center - lineLength/2 + jitter); % Here position of line is jittered
    x2 = round(center + lineLength/2 + jitter);% Here position of line is jittered
    
    %DisplayInstructs1; 
    
    %practice trials
    left_end = '0';
    right_end = '100';
    task = 1;
    p_points = 0;
    block_p_points = 0;
    prac1 = [10 0.1];
    prac2 = [50 0.5];
    prac3 = [80 0.8];
    
    block_p_points = Practice_TrialLoop(prac1,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,3,4,1,task);
    block_p_points = Practice_TrialLoop(prac2,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,5,3,0,task);
    block_p_points = Practice_TrialLoop(prac3,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,6,5,0,task);
    p_points = block_p_points + p_points;
    
    DisplayInstructsPractice;
    
    block_p_points = 0;
    left_end = '-100';
    right_end = '100';
    task = 1;
    prac4 = [-20 0.4];
    prac5 = [25 0.625];
    prac6 = [-95 0.025];
    
    block_p_points = Practice_TrialLoop(prac4,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,5,3,0,task);
    block_p_points = Practice_TrialLoop(prac5,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,4,4,1,task);
    block_p_points = Practice_TrialLoop(prac6,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,3,6,0,task);
    p_points = block_p_points + p_points;
    
    %control task
    DisplayInstructsPractice;
    
    block_p_points = 0;
    left_end = 'xx';
    right_end = 'xx';
    task =2;
    prac7 = {'me' 0.4 'is'};
    prac8 = {'be' 0.75 'be'};
    prac9 = {'of' 0.33 'of'}; %I'm here need to change the rest of the code
    block_p_points = Practice_TrialLoop(prac7,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,5,3,1,task);
    block_p_points = Practice_TrialLoop(prac8,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,4,4,0,task);
    block_p_points = Practice_TrialLoop(prac9,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,3,6,0,task);
    p_points = block_p_points + p_points;
    DisplayInstructs4; %End of practice ask question and get ready to start   
    
    blockNbr_Nline = 0;
    
    % The idea is the kk will signal
    % which portion of the 3D matrix will be used for the
    % rest of the code and in principle the rest should not be changed
    %start_t0 = GetSecs;
    p.start_Nline=datestr(now); % for record purpose
    for kk = 1:p.runs;
    
        block_points = points;
        % wait for scanner trigger '5'
        DrawCenteredNum('Waiting for experimenter', win, color, 0.3);
        WaitTill('9');
        DrawCenteredNum('Waiting for scanner', win, color, 0.3);
        WaitTill('5'); %Use this only if used in a scanner that sends 5
        start_t = GetSecs;
            
        for ii = 1:(p.ntasks);
            blockNbr_Nline = blockNbr_Nline+1;
            for jj = 1:p.nStim;
                trialNbr_Nline = (p.nStim * (blockNbr_Nline-1)) + jj; % This counts across blocks
                trialNbr = jj; %This counts within block
                end_ITI = p.NlineResults{trialNbr+1,19,kk} + start_t;
                end_consider = p.NlineResults{trialNbr+1,20,kk} + start_t;
                end_hold = p.NlineResults{trialNbr+1,21,kk} + start_t;
                end_decision = p.NlineResults{trialNbr+1,22,kk} + start_t;
                % I'M HERE... NEED TO REMOVE THE NEXT LINES AND REPLACE
                % WITH A TRIALLOOP CALL THAT MAKES SENSE AND LOGS WHAT I
                % NEED TO LOG
                DrawCenteredNum_Abs('X', win, color);
                p.NlineResults(trialNbr+1,14,kk) = {GetSecs - start_t}; %Real onset of fixation
                WaitTill(end_ITI);
                %%% I need to pass end_time to the functions so that they can
                %%% use it to figure when to exit from the script
                p.NlineResults(trialNbr+1,15,kk) = {GetSecs - start_t}; %Real onset of deciison
                p.NlineResults(trialNbr+1,3:8,kk) = NumLineSlow_Abs(NlineTest(trialNbr,:,kk), win, color, end_decision, points);
                WaitTill(end_decision);
                p.NlineResults(trialNbr+1,9,kk) = {trialNbr_Nline};
                p.NlineResults(trialNbr+1,10,kk) = {blockNbr_Nline};
                points = p.NlineResults{trialNbr+1,7,kk};
            end
        end
        end_t = GetSecs - start_t;
        p.time_Runs(kk+1,1) = {end_t};
        block_points = points - block_points;
        DrawCenteredNum(fix, win, color, 4);%fixation to pad end of scan
        DisplayInstructs2;
    end
    
    %end_t = GetSecs - start_t0;
    p.finish_Nline = datestr(now);
catch
    ple
    ShowCursor;
    sca
    save([filename '_catch2']);
    save(filename, 'p');
    ListenChar(1);

end