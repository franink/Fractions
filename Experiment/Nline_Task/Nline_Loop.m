function [p, points, block_points] = Nline_Loop(filename, win, color, p, points, TestNline, block_points, lineLength)
%Controls the loop that executes fraction summation task
%returns p struct with all the results and stim logged and updated points
%for measure of accuracy

% Nline task

try
    task_name_time = 2;
    feedback_end = 4;
    
    winRect = Screen('Rect', win);
    yline = round(winRect(4)/2);
    center = winRect(3)/2;
    
    ppc_adjust = 23/38;
  
    lineLength = round(lineLength*ppc_adjust);
    lineSZ = round(20*ppc_adjust);
    
    rng shuffle;
    jitter = 0;
    jitter = jitter*randi([-300 300]);
    jitter = round(jitter*ppc_adjust);% Here position of line is jittered
    
    x1 = round(center - lineLength/2 + jitter); % Here position of line is jittered
    x2 = round(center + lineLength/2 + jitter);% Here position of line is jittered
    
    DisplayInstructs1; 
    
    %practice trials
    left_end = '0';
    right_end = '100';
    task = 1;
    p_points = 0;
    block_p_points = 0;
    p_move = 0;
    p_slow = 0;
    p_wrong = 0;
    p_badpress = 0;
    prac1 = [10 0.1];
    prac2 = [50 0.5];
    prac3 = [80 0.8];
    prac4 = [35 0.35];
    [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(prac1,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,3,3.5,0,task,p_move,p_slow,p_wrong,p_badpress,p.speed);
    [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(prac2,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,4,3,1,task,p_move,p_slow,p_wrong,p_badpress,p.speed);
    [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(prac3,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,5,4,0,task,p_move,p_slow,p_wrong,p_badpress,p.speed);
    [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(prac4,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,3,3.5,1,task,p_move,p_slow,p_wrong,p_badpress,p.speed);
    p_points = block_p_points + p_points;
    
    DisplayInstructsPractice;
    DisplayInstructs5;
    
    block_p_points = 0;
    left_end = '-100';
    right_end = '100';
    task = 1;
    p_move = 0;
    p_slow = 0;
    p_wrong = 0;
    p_badpress = 0;
    prac5 = [-20 0.4];
    prac6 = [25 0.625];
    prac9 = [-95 0.025];
    prac10 = [73 0.865];
    
    [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(prac5,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,4,2.5,0,task,p_move,p_slow,p_wrong,p_badpress,p.speed);
    [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(prac6,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,3,3,1,task,p_move,p_slow,p_wrong,p_badpress,p.speed);
    [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(prac9,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,2.5,3.5,1,task,p_move,p_slow,p_wrong,p_badpress,p.speed);
    [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(prac10,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,3,5.5,0,task,p_move,p_slow,p_wrong,p_badpress,p.speed);
    p_points = block_p_points + p_points;
    
    %control task
    DisplayInstructsPractice;
    DisplayInstructs6;
    block_p_points = 0;
    left_end = 'xx';
    right_end = 'xx';
    task =2;
    p_move = 0;
    p_slow = 0;
    p_wrong = 0;
    p_badpress = 0;
    prac9 = {'me' 0.4 'is'};
    prac10 = {'be' 0.75 'be'};
    prac11 = {'of' 0.33 'of'};
    prac12 = {'my' 0.11 'ox'};
    
    [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(prac9,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,4,2.5,1,task,p_move,p_slow,p_wrong,p_badpress,p.speed);
    [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(prac10,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,3,4,0,task,p_move,p_slow,p_wrong,p_badpress,p.speed);
    [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(prac11,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,2.5,3.5,1,task,p_move,p_slow,p_wrong,p_badpress,p.speed);
    [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(prac12,block_p_points,p.decision,left_end,right_end,lineLength,lineSZ,jitter,ppc_adjust,win,color,x1,x2,yline,center,winRect,3.5,4,0,task,p_move,p_slow,p_wrong,p_badpress,p.speed);
    p_points = block_p_points + p_points;
    DisplayInstructs4; %End of practice ask question and get ready to start   
    
    
    
    % The idea is the kk will signal
    % which portion of the 3D matrix will be used for the
    % rest of the code and in principle the rest should not be changed
    %start_t0 = GetSecs;
    p.start_Nline=datestr(now); % for record purpose
    for kk = 1:p.runs;
        blockNbr_Nline = 0;
        % wait for scanner trigger '5'
        DrawCenteredNum('Waiting for experimenter', win, color, 0.3);
        WaitTill('9');
        DrawCenteredNum('Waiting for scanner', win, color, 0.3);
        WaitTill('5'); %Use this only if used in a scanner that sends 5
        start_t = GetSecs;
            
        for ii = 1:(p.ntasks);
            block_points = points;
            move = 0;
            slow= 0;
            wrong = 0;
            badpress = 0;
            blockNbr_Nline = blockNbr_Nline+1;
            task = TestNline{(ii-1)*p.nStim + 1, 5, kk};
            if task == 1;
                taskname = '0 to 100 task';
                left_end = '0';
                right_end = '100';
            end
            if task == 2;
                taskname = '-100 to 100 task';
                left_end = '-100';
                right_end = '100';
            end
            if task == 3;
                taskname = 'Word task';
                left_end = 'xx';
                right_end = 'xx';
            end
            DrawTaskName(taskname,win,color,task_name_time, task); % Task name
            DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust,...
                win, color, x1, x2, yline, center, winRect, 0);
            Screen('Flip', win);
            WaitTill(start_t + p.ramp_up);
            for jj = 1:p.nStim;
                trialNbr = (p.nStim * (blockNbr_Nline-1)) + jj; % This counts across blocks
                trialNbr_Nline = jj; %This counts within block
                end_ITI = p.NlineResults{trialNbr+1,23,kk} + start_t;
                end_consider = p.NlineResults{trialNbr+1,24,kk} + start_t;
                end_hold = p.NlineResults{trialNbr+1,25,kk} + start_t;
                end_decision = p.NlineResults{trialNbr+1,26,kk} + start_t;
                p.NlineResults{trialNbr+1,1,kk} = TestNline{trialNbr,5,kk}; %Task number
                p.NlineResults(trialNbr+1,2:4,kk) = TestNline(trialNbr,1:3,kk); %probe, line_pct, catch
                p.NlineResults{trialNbr+1,32,kk} = TestNline{trialNbr,4,kk}; %Catch probe
                
                [p.NlineResults(trialNbr+1,27:31,kk), p.NlineResults(trialNbr+1,7:19,kk)] =...
                    TrialLoop(TestNline(trialNbr,:,kk),points, left_end, right_end, lineLength,...
                    lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, TestNline{trialNbr,3,kk},...
                    task, start_t, end_ITI, end_consider, end_hold, end_decision, move, slow, wrong, badpress,p.speed);
                    
                p.NlineResults(trialNbr+1,20,kk) = {trialNbr_Nline}; %trial number within block
                p.NlineResults(trialNbr+1,21,kk) = {blockNbr_Nline}; %block number
                points = p.NlineResults{trialNbr+1,15,kk};
                move = p.NlineResults{trialNbr+1,16,kk};
                slow = p.NlineResults{trialNbr+1,17,kk};
                wrong = p.NlineResults{trialNbr+1,18,kk};
                badpress = p.NlineResults{trialNbr+1,19,kk};
            end
            block_points = points - block_points;
            DisplayInstructs2; %error feedback
        end
        end_t = GetSecs - start_t;
        p.time_Runs(2,kk) = {end_t};
        %DrawCenteredNum(fix, win, color, 4);%fixation to pad end of scan
        DisplayInstructs3; %Rest break
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