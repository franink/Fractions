function [p] = Run_Loop(filename, win, p, stim, dimStim)
%Controls the loop for each run of IEM task
%   returns p struct with all data, saves partial data if something fails

try
        
    DisplayInstructs1;
    
    %any practice we decide to do goes here
    left = [p.center(1), p.center(2)];

    xLoc = 2;
    yLoc = 0;

    stimRect = [p.center(1) + p.radPix*(xLoc) - p.radPix, p.center(2) + p.radPix*(yLoc) - p.radPix,...
                p.center(1) + p.radPix*(xLoc) + p.radPix, p.center(2) + p.radPix*(yLoc) + p.radPix];
    
    practdimsequence = zeros(1, p.stimExpose);
    practdimsequence(100:120) = 1;
    start_prac = GetSecs;
    Screen('DrawDots', win, [0,0], p.fixSizePix, p.fixColor, left, 0);
    Screen('DrawingFinished', win);
    Screen('Flip', win);
    WaitTill(start_prac + 3);
    
    FlushEvents;
    pracResp = 0;
    frmCnt=1; %frame count
    while frmCnt<=p.stimExpose
        if practdimsequence(frmCnt)
            Screen('DrawTexture',win,dimStim(p.flickerSequ(1,frmCnt)),Screen('Rect',dimStim(p.flickerSequ(1,frmCnt))),stimRect);
        else
            Screen('DrawTexture',win,stim(p.flickerSequ(1,frmCnt)),Screen('Rect',stim(p.flickerSequ(1,frmCnt))),stimRect);
        end
        
        %Redraw fixation
        Screen('DrawDots', win, [0,0], p.fixSizePix, p.fixColor, left, 0); %change fixation point
        Screen('DrawingFinished', win); % Tell PTB that no further drawing commands will follow before Screen('Flip')
        Screen('Flip', win);
        
      
        [prac, timeStamp] = ReadKey('1'); % buttons need to be decided
        if~isempty(prac);
            %pracResp;
            pracResp = 1;
        end
        frmCnt = frmCnt + 1;
    end
    pracResp
    DisplayInstructsPract; 
    
    p.start_Exp =datestr(now); % for record purpose
    
    DrawCenteredNum('Start Run? (1-4)', win, p, 0.3);
    [pract secs] = WaitTill({'1' '2' '3' '4'});
    pract = str2num(pract);
    for r= pract:p.runs
        %Allow program to move to wait for scanner screen
        DrawCenteredNum('Waiting for experimenter', win, p, 0.3);
        WaitTill('9');
        %% Eye tracker section
        if p.eyetrack
            % Sending a 'TRIALID' message to mark the start of a trial in Data 
            % Viewer.  This is different than the start of recording message 
            % START that is logged when the trial recording begins. The viewer
            % will not parse any messages, events, or samples, that exist in 
            % the data file prior to this message. 
            Eyelink('Message', 'RUNID %d', r);

            % This supplies the title at the bottom of the eyetracker display
            Eyelink('command', 'record_status_message "RUN %d"', r); 
            % Before recording, we place reference graphics on the host display
            % Must be offline to draw to EyeLink screen
            Eyelink('Command', 'set_idle_mode');
            % clear tracker display and draw box at center
            Eyelink('Command', 'clear_screen 0')
            width = p.sRect(3) - p.sRect(1);
            height = p.sRect(4) - p.sRect(2);
            Eyelink('command', 'draw_box %d %d %d %d 15', width/2-50, height/2-50, width/2+50, height/2+50);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Do a drift correction at the beginning of each trial
            % Performing drift correction (checking) is optional for
            % EyeLink 1000 eye trackers.
            EyelinkDoDriftCorrection(el);
            
            % start recording eye position (preceded by a short pause so that 
            % the tracker can finish the mode transition)
            % The paramerters for the 'StartRecording' call controls the
            % file_samples, file_events, link_samples, link_events availability
            Eyelink('Command', 'set_idle_mode');
            WaitSecs(0.05);
    %         Eyelink('StartRecording', 1, 1, 1, 1);    
            Eyelink('StartRecording');    
            % record a few samples before we actually start displaying
            % otherwise you may lose a few msec of data 
            
            
        end
        
        %% End of eye tracker
        % wait for scanner trigger '5'
        DrawCenteredNum('Waiting for scanner', win, p, 0.3);
        WaitTill('5'); %Use this only if used in a scanner that sends 5
        %DrawCenteredNum('Ready', win, p, 0.3);
        
%% Remember to uncomment this for the scanner        
        % Send trigger to scanner
%         s = serial('/dev/tty.usbmodem12341', 'BaudRate', 57600);
%         fopen(s);
%         fprintf(s, '[t]');
%         fclose(s);
%% Uncomment above for scanner
        
        start_t = GetSecs;
        
        p.startRun(r) = start_t;
        %WaitTill(start_t + p.ramp_up);
        
        for t = 1:p.nTrials
            
            end_ITI = p.StimOnset(t,r) + start_t;
            end_Stim = p.StimEnd(t,r) + start_t;
            
            p = TrialLoop(p,t,r,stim, dimStim, end_ITI, end_Stim, start_t, win); %This loop draws a fixation and draws a stim
            
        end
        
        p.endRun(r) = GetSecs;
        p.durRun(r) = p.endRun(r) - p.startRun(r);
        
        %%eye tracker section
        if p.eyetrack
            WaitSecs(0.1);
            % stop the recording of eye-movements for the current trial
            Eyelink('StopRecording');
        end
        %% end of eye track section
        DisplayInstructs3; %Rest break (Again Number of file might change once I figure how many instructions I need
    end
    
    p.endExp = datestr(now);
    
    catch
    ple
    ShowCursor;
    save([filename '_catch']);
    save(filename, 'p');
    if p.eyetrack
        Eyelink('ShutDown');
    end
    sca
    ListenChar(1);

end

